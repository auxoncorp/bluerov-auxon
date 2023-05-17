#!/usr/bin/env python
import sys
import rclpy
import random
import threading
import time

from rclpy.node import Node

from sensor_msgs.msg import LaserScan
from mavros_wrapper.ardusub_wrapper import *
from modality.sdk import IngestClient, TimelineId, AttrVal, AttrList

def laser_scan_cb(msg, ardusub, ic):
    min_distance = 1.5
    yaw_speed = 0.3
    forward_speed = 0.15
    allGreater = True
    for scan in msg.ranges:
        if scan < min_distance:
            allGreater = False
            _yaw_speed = (-1)**random.choice([1, 2])*yaw_speed
            ardusub.set_rc_override_channels(
                forward=-forward_speed/4,
                yaw=_yaw_speed)
            break
    if allGreater:
        cb_attrs = AttrList(3)
        v0 = AttrVal()
        v0.set_string('setting-rc-overrides')
        cb_attrs[0].key = ic.declare_attr_key('event.name')
        cb_attrs[0].value = v0
        v1 = AttrVal()
        v1.set_float(forward_speed)
        cb_attrs[1].key = ic.declare_attr_key('event.forward_speed')
        cb_attrs[1].value = v1
        v2 = AttrVal()
        v2.set_timestamp(time.time_ns())
        cb_attrs[2].key = ic.declare_attr_key('event.timestamp')
        cb_attrs[2].value = v2
        ic.event(cb_attrs)
        ardusub.set_rc_override_channels(forward=forward_speed)


if __name__ == '__main__':
    print("Starting wall avoidance. Let's swim!")

    ic = IngestClient()
    ic.connect(url='modality-ingest://172.18.0.1:15182', timeout_seconds=10)
    ic.authenticate()
    t_attrs = AttrList(2)
    tid = TimelineId()
    v = AttrVal()
    v.set_timeline_id(tid)
    t_attrs[0].key = ic.declare_attr_key('timeline.id')
    t_attrs[0].value = v
    v = AttrVal()
    v.set_string('wall-avoidance-test')
    t_attrs[1].key = ic.declare_attr_key('timeline.name')
    t_attrs[1].value = v
    ic.open_timeline(tid, t_attrs)

    # Initialize ros node
    rclpy.init(args=sys.argv)

    ardusub = BlueROVArduSubWrapper("ardusub_node")

    thread = threading.Thread(target=rclpy.spin, args=(ardusub, ), daemon=True)
    thread.start()

    service_timer = ardusub.create_rate(2)
    while ardusub.status.mode != "ALT_HOLD":
        ardusub.set_mode("ALT_HOLD")
        service_timer.sleep()

    print("ALT HOLD mode selected")
    e_attrs = AttrList(2)
    v0 = AttrVal()
    v0.set_timestamp(time.time_ns())
    e_attrs[0].key = ic.declare_attr_key('event.timestamp')
    e_attrs[0].value = v0
    v1 = AttrVal()
    v1.set_string('alt-hold-selected')
    e_attrs[1].key = ic.declare_attr_key('event.name')
    e_attrs[1].value = v1
    ic.event(e_attrs)

    while ardusub.status.armed == False:
        ardusub.arm_motors(True)
        service_timer.sleep()

    print("Thrusters armed")
    e_attrs = AttrList(2)
    v0 = AttrVal()
    v0.set_timestamp(time.time_ns())
    e_attrs[0].key = ic.declare_attr_key('event.timestamp')
    e_attrs[0].value = v0
    v1 = AttrVal()
    v1.set_string('thrusters-armed')
    e_attrs[1].key = ic.declare_attr_key('event.name')
    e_attrs[1].value = v1
    ic.event(e_attrs)

    print("Initializing mission")

    ardusub.toogle_rc_override(True)
    ardusub.set_rc_override_channels(forward=0.35)

    laser_subscriber = ardusub.create_subscription(
        LaserScan, '/scan', (lambda msg: laser_scan_cb(msg, ardusub, ic)), 10)

    rate = ardusub.create_rate(2)
    try:
        while rclpy.ok():
            rate.sleep()
    except KeyboardInterrupt:
        pass

    ic.close_timeline()

    ardusub.destroy_node()
    rclpy.shutdown()
