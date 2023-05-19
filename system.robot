# git clone --depth 1 https://github.com/auxoncorp/modality-sdk.git --branch more-python repo
# install to /opt/modality-sdk
# run with:
# LD_LIBRARY_PATH=/opt/modality-sdk/lib/ PYTHONPATH=/opt/modality-sdk/python robot system.robot

*** Settings ***
Library  OperatingSystem
Library  Process
Library  Dialogs
Library  ModalityLibrary.py

Suite Setup     Suite Setup
Suite Teardown  Suite Teardown
Test Setup      Test Setup
Test Teardown   Test Teardown

Documentation
...  Execute the bluerov system

*** Variables ***
${MODALITY_AUTH_TOKEN}          %{MODALITY_AUTH_TOKEN}
${LOCAL_SDK_PATH}               /opt/modality-sdk

*** Keywords ***
Suite Setup
    Run Process                 modality  config  --modalityd http://localhost:14181/v1/
    Run Process                 modality  workspace  use  demo
    Run Process                 modality  segment  use  --latest
    Run Process                 modality  log  ignore  --clear

    ${run_id}=                  Setup Run Id Cache File  run_id.cache
    Set Environment Variable    MODALITY_RUN_ID  ${run_id}

    Start Modality Reflector
    Connect To Modality         ${MODALITY_AUTH_TOKEN}
    Open Suite Timeline         ${SUITE_NAME}
    Log Suite Setup             ${SUITE_NAME}

Suite Teardown
    Log Suite Teardown          ${SUITE_NAME}
    Close Suite Timeline
    Wait For Suite Teardown Event
    Terminate All Processes

Test Setup
    Log Test Setup              ${TEST_NAME}

Test Teardown
    Run Keyword If Test Failed
      ...   Log Test Failure    ${TEST_NAME}
    Log Test Teardown           ${TEST_NAME}

Wait For Suite Teardown Event
    Log                         Waiting for suite teardown event to be received  console=false
    ${e_at_t}=                  Set Variable  teardown_suite @ robot_framework
    ${pred}=                    Set Variable  _.robot_framework.suite.name = '${SUITE_NAME}'
    ${agg}=                     Set Variable  AGGREGATE count() = 1
    ${result}=                  Run Process  modality  wait-until  --deadline\=35s  --whole-workspace  ${e_at_t} (${pred}) ${agg}
    Should Be Equal 	        ${result.rc}  ${0}

Wait For Gazebo Model
    Log                         Waiting for the bluerov2 Gazebo model to be up  console=false
    ${e_at_t}=                  Set Variable  pose@bluerov2
    ${agg}=                     Set Variable  AGGREGATE count() > 0
    ${result}=                  Run Process  modality  wait-until  --deadline\=35s  --whole-workspace  ${e_at_t} ${agg}
    Should Be Equal 	        ${result.rc}  ${0}

Start Modality Reflector
    Start Process               modality-reflector  run  --config  reflector-config.toml  alias=reflector
    Sleep                       2

Start Simulator
    Set Environment Variable    DOCKER_OPTS  -d\=true
    ${result}=                  Run Process  ./run_sim.sh "/launch.sh"  shell=true
    Should Be Equal 	        ${result.rc}  ${0}

Start Bluerov
    Set Environment Variable    DOCKER_OPTS  -d\=true
    ${result}=                  Run Process  ./run_bluerov.sh "/launch.sh"  shell=true
    Should Be Equal 	        ${result.rc}  ${0}

Stop System
    Run Process                 docker  stop  bluerov
    Run Process                 docker  stop  bluerov_sim

*** Test Cases ***
Avoid Walls
    [Documentation]             Run the random wall avoidance algorithm
    [Tags]                      ros  bluerov  gazebo

    Start Simulator
    Wait For Gazebo Model
    Start Bluerov
    Pause Execution             Press OK to stop the system
    Stop System
