*** Settings ***
Library  OperatingSystem
Library  Process
Library  Dialogs

Suite Setup     Suite Setup
Test Setup      Test Setup
Test Teardown   Test Teardown

Documentation
...    Execute the bluerov system

*** Variables ***
${GZ_PARTITION}                 "bluerov_sim:docker"
${MODALITY_AUTH_TOKEN}          %{MODALITY_AUTH_TOKEN}

*** Keywords ***
Suite Setup
    Set Environment Variable    MODALITY_AUTH_TOKEN  ${MODALITY_AUTH_TOKEN}
    Run Process                 modality  config  --modalityd http://localhost:14181/v1/
    Run Process                 modality  workspace  use  demo
    Run Process                 modality  segment  use  --all-segments
    Run Process                 modality  log  ignore  --clear

Test Setup
    # TODO
    Set Environment Variable    MODALITY_AUTH_TOKEN  ${MODALITY_AUTH_TOKEN}

Test Teardown
    Terminate All Processes

Start Modality Reflector
    Start Process               modality-reflector  run  --config  reflector-config.toml  alias=reflector

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
    Terminate All Processes

*** Test Cases ***
Execute the System
    [Documentation]             Executes the system
    [Tags]                      test  bluerov  gazebo

    Start Modality Reflector
    Start Simulator
    # TODO setup a keyword to pause until sim transport is up
    #Sleep                       10s
    Pause Execution             Press OK to launch bluerov
    Start Bluerov
    Pause Execution             Press OK to stop the system
    Stop System
