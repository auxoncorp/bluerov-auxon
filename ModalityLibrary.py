import uuid
from pathlib import Path
import os
import time
from modality.sdk import IngestClient, TimelineId, AttrVal, AttrList

__version__ = '0.1.0'

class ModalityLibrary(object):
    ROBOT_LIBRARY_VERSION = __version__
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    TIMELINE_NAME = 'robot_framework'

    def __init__(self):
        self.ic = IngestClient()

    def setup_run_id_cache_file(self, path):
        if not os.path.exists(path):
            with open(path, 'w+') as f:
                f.write('0')
            return '0'
        else:
            run_id = int(Path(path).read_text().replace('\n', ''))
            next_run_id = str(run_id + 1)
            with open(path, 'w+') as f:
                f.write(next_run_id)
            return next_run_id

    def connect_to_modality(self, url, auth_token):
        self.ic.connect(url=url, timeout_seconds=10)
        self.ic.authenticate(auth_token=auth_token)

    def open_suite_timeline(self, suite_name):
        self.suite_tid = TimelineId()

        t_attrs = AttrList(4)
        a = AttrVal()
        a.set_timeline_id(self.suite_tid)
        t_attrs[0].key = self.ic.declare_attr_key('timeline.id')
        t_attrs[0].value = a

        # Provide a default run_id, overridden by MODALITY_RUN_ID
        self.run_id = uuid.uuid4()
        b = AttrVal()
        b.set_string(str(self.run_id))
        t_attrs[1].key = self.ic.declare_attr_key('timeline.run_id')
        t_attrs[1].value = b

        c = AttrVal()
        c.set_string(self.TIMELINE_NAME)
        t_attrs[2].key = self.ic.declare_attr_key('timeline.name')
        t_attrs[2].value = c

        d = AttrVal()
        d.set_string(suite_name)
        t_attrs[3].key = self.ic.declare_attr_key('timeline.robot_framework.suite.name')
        t_attrs[3].value = d

        self.ic.open_timeline(self.suite_tid, t_attrs)

    def close_suite_timeline(self):
        self.ic.close_timeline()

    def log_suite_setup(self, suite_name):
        now = time.time_ns()

        e_attrs = AttrList(3)
        v = AttrVal()
        v.set_string('setup_suite')
        e_attrs[0].key = self.ic.declare_attr_key('event.name')
        e_attrs[0].value = v

        r = AttrVal()
        r.set_string(suite_name)
        e_attrs[1].key = self.ic.declare_attr_key('event.robot_framework.suite.name')
        e_attrs[1].value = r

        t = AttrVal()
        t.set_timestamp(now)
        e_attrs[2].key = self.ic.declare_attr_key('event.timestamp')
        e_attrs[2].value = t

        self.ic.event(e_attrs)

    def log_suite_teardown(self, suite_name):
        now = time.time_ns()

        e_attrs = AttrList(3)
        v = AttrVal()
        v.set_string('teardown_suite')
        e_attrs[0].key = self.ic.declare_attr_key('event.name')
        e_attrs[0].value = v

        r = AttrVal()
        r.set_string(suite_name)
        e_attrs[1].key = self.ic.declare_attr_key('event.robot_framework.suite.name')
        e_attrs[1].value = r

        t = AttrVal()
        t.set_timestamp(now)
        e_attrs[2].key = self.ic.declare_attr_key('event.timestamp')
        e_attrs[2].value = t

        self.ic.event(e_attrs)

    def log_test_setup(self, test_name):
        now = time.time_ns()

        e_attrs = AttrList(3)
        v = AttrVal()
        v.set_string('setup_test')
        e_attrs[0].key = self.ic.declare_attr_key('event.name')
        e_attrs[0].value = v

        r = AttrVal()
        r.set_string(test_name)
        e_attrs[1].key = self.ic.declare_attr_key('event.robot_framework.test.name')
        e_attrs[1].value = r

        t = AttrVal()
        t.set_timestamp(now)
        e_attrs[2].key = self.ic.declare_attr_key('event.timestamp')
        e_attrs[2].value = t

        self.ic.event(e_attrs)

    def log_test_teardown(self, test_name):
        now = time.time_ns()

        e_attrs = AttrList(3)
        v = AttrVal()
        v.set_string('teardown_test')
        e_attrs[0].key = self.ic.declare_attr_key('event.name')
        e_attrs[0].value = v

        r = AttrVal()
        r.set_string(test_name)
        e_attrs[1].key = self.ic.declare_attr_key('event.robot_framework.test.name')
        e_attrs[1].value = r

        t = AttrVal()
        t.set_timestamp(now)
        e_attrs[2].key = self.ic.declare_attr_key('event.timestamp')
        e_attrs[2].value = t

        self.ic.event(e_attrs)

    def log_test_failure(self, test_name):
        now = time.time_ns()

        e_attrs = AttrList(3)
        v = AttrVal()
        v.set_string('test_failure')
        e_attrs[0].key = self.ic.declare_attr_key('event.name')
        e_attrs[0].value = v

        r = AttrVal()
        r.set_string(test_name)
        e_attrs[1].key = self.ic.declare_attr_key('event.robot_framework.test.name')
        e_attrs[1].value = r

        t = AttrVal()
        t.set_timestamp(now)
        e_attrs[2].key = self.ic.declare_attr_key('event.timestamp')
        e_attrs[2].value = t

        self.ic.event(e_attrs)
