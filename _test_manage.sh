#!/usr/bin/env bash
#
# Test functions for `manage.sh`
# Spencer Butler <dev@tcos.us>

RETURN_VAL=1
TEST_SCRIPT=./manage.sh
declare -A TESTS
declare -A DEBUG
SCORE=0

_test_get_help_is_always_help() {
    # TODO(spencer) remove output, or just ditch this test -- it's dumb.
    HASH=$("$TEST_SCRIPT" | md5sum)
    _hHASH=$("$TEST_SCRIPT" -h | md5sum)
    _helpHASH=$("$TEST_SCRIPT" --help 2>&1 | md5sum)
    #HASH=

    DEBUG_VALS=$(cat  << EOF
These hashes should all match.
    HASH        '$HASH'
    _hHASH      '$_hHASH'

This value should never match.
    _helpHASH   '$_helpHASH'
EOF
)
    retval=1
    if [  "$HASH" = "$_hHASH" ]
    then
        if [ ! "$HASH" = "$_helpHASH" ]
        then 
            retval=0
        else
            DEBUG_VALS="${DEBUG_VALS}\nFAIL:\n\tHASH:\t${HASH}\n\t_helpHASH:\t${_helpHASH}\n"
        fi
    else
        DEBUG_VALS="${DEBUG_VALS}\nFAIL:\n\tHASH:\t${HASH}\n\t_hHASH:\t${_hHASH}\n"

    fi
        
    return "$retval"
}


_test_parse_config_returns_all_variables() {
    TEST_NAME=radarr
    TEST_PORT=7878
    TEST_PROVIDER=linuxserver/
    TEST_ENABLED=true
     # shellcheck disable=SC1090
    . "$TEST_SCRIPT"
   parse_config "$TEST_NAME" "$STACK_ITEMS" -z

    DEBUG_VALS=$(cat << EOF
These values should all match:
    NAME:
        '$TEST_NAME'
        '$NAME'
    PORT:
        '$TEST_PORT'
        '$PORT'
    PROVIDER:
        '$TEST_PROVIDER'
        '$PROVIDER'
    ENABLED:
        '$TEST_ENABLED'
        '$ENABLED'
EOF
)
    retval=1
    if [ "$NAME" = "$TEST_NAME" ] 
    then
        if [ "$PORT" = "$TEST_PORT" ]
        then
            if [ "$PROVIDER" = "$TEST_PROVIDER" ]
            then
                if [ "$ENABLED" = "$TEST_ENABLED" ]
                then
                    retval=0
                else
                    DEBUG_VALS="${DEBUG_VALS}\nFAIL:\n\tENABLED:\t${ENABLED}\n\tTEST_ENABLED:\t${TEST_ENABLED}\n"
                fi
            else
                DEBUG_VALS="${DEBUG_VALS}\FAIL:\n\tPROVIDER:\t${PROVIDER}\n\tTEST_PROVIDER:\t${TEST_PROVIDER}\n"
            fi
        else
            DEBUG_VALS="${DEBUG_VALS}\nFAIL:\n\tPORT:\t\t${PORT}\n\tTEST_PORT:\t${TEST_PORT}\n"
        fi
    else
        DEBUG_VALS="${DEBUG_VALS}\nFAIL:\n\tNAME:\t${NAME}\n\tTEST_NAME:\t${TEST_NAME}\n"
    fi
    return "$retval"
}


_test_get_items_returns_all_variables() {
    TEST_NAME=readarr # last entry in `STACK_ITEMS`
    TEST_ENABLED=true
    TEST_ALL_ITEMS='traefik bazarr lidarr nzbget plex radarr sabnzbd sonarr tautulli'
    TEST_ENABLED_ITEMS='bazarr lidarr plex radarr sabnzbd sonarr tautulli traefik'
    TEST_DISABLED_ITEMS='nzbget'
     # shellcheck disable=SC1090
    . "$TEST_SCRIPT"
    get_items

    DEBUG_VALS=$(cat << EOF
These values should all match:
    NAME:
        '$TEST_NAME'
        '$NAME'
    ENABLED:
        '$TEST_ENABLED'
        '$ENABLED'
    ALL_ITEMS:
        '$TEST_ALL_ITEMS'
        '$ALL_ITEMS'
    ENABLED_ITEMS:
        '$TEST_ENABLED_ITEMS'
        '$ENABLED_ITEMS'
    DISABLED_ITEMS:
        '$TEST_DISABLED_ITEMS'
        '$DISABLED_ITEMS'
EOF
)
    retval=1
    if [ "$NAME" = "$TEST_NAME" ] 
    then
        if [ "$ALL_ITEMS" = "$TEST_ALL_ITEMS" ]
        then
            if [ "$ENABLED_ITEMS" = "$TEST_ENABLED_ITEMS" ]
            then
                if [ "$ENABLED_ITEMS" = "$TEST_ENABLED_ITEMS" ]
                then
                    if [ "$ENABLED" = "$TEST_ENABLED" ]
                    then
                        retval=0
                    else
                        DEBUG_VALS="${DEBUG_VALS}\nFAIL:\n\tENABLED:\t${ENABLED}\n\tTEST_ENABLED:\t${TEST_ENABLED}\n"
                    fi
                else
                    DEBUG_VALS="${DEBUG_VALS}\FAIL:\n\tDISABLED_ITEMS:\t${DISABLED_ITEMS}\n\tTEST_DISABLED_ITEMSR:\t${TEST_DISABLED_ITEMS}\n"
                fi
            else
                DEBUG_VALS="${DEBUG_VALS}\FAIL:\n\tENABLED_ITEMS:\t${ENABLED_ITEMS}\n\tTEST_ENABLED_ITEMSR:\t${TEST_ENABLED_ITEMS}\n"
            fi
        else
            DEBUG_VALS="${DEBUG_VALS}\FAIL:\n\tALL_ITEMS:\t${ALL_ITEMS}\n\tTEST_ALL_ITEMSR:\t${TEST_ALL_ITEMS}\n"
        fi
    else
        DEBUG_VALS="${DEBUG_VALS}\nFAIL:\n\tNAME:\t${NAME}\n\tTEST_NAME:\t${TEST_NAME}\n"
    fi
    return "$retval"
}

run_tests() {
    _test_get_help_is_always_help
    TESTS["_test_get_help_is_always_help"]="$retval" ; unset retval
    DEBUG["_test_get_help_is_always_help"]="$DEBUG_VALS" ; unset DEBUG_VALS

    _test_parse_config_returns_all_variables
    TESTS["_test_parse_config_returns_all_variables"]="$retval" ; unset retval
    DEBUG["_test_parse_config_returns_all_variables"]="$DEBUG_VALS" ; unset DEBUG_VALS

    _test_get_items_returns_all_variables
    TESTS["_test_get_items_returns_all_variables"]="$retval" ; unset retval
    DEBUG["_test_get_items_returns_all_variables"]="$DEBUG_VALS" ; unset DEBUG_VALS

    # Tally Score
    for TEST in "${!TESTS[@]}"
    do
        SCORE=$(( SCORE + TESTS[$TEST] ))
    done

    # Grade Score
    if [ "$SCORE" -eq 0 ]
    then
        echo "All Tests passed!"
        echo
        RETURN_VAL=0

    else
        echo "Some tests did not pass."
        echo
    fi

    # Report Score.
    echo "Report for \"$TEST_SCRIPT\"."
    echo =============================
    echo "Score: $SCORE"

    for TEST in "${!TESTS[@]}"
    do

        if [ "${TESTS[$TEST]}" -eq 0 ]
        then
            echo "PASS TEST: $TEST ${TESTS[$TEST]}"

        else
            echo -e "FAIL TEST: ${TEST} ${TESTS[$TEST]}\n${DEBUG[$TEST]}"
        fi
    done

    return "$RETURN_VAL"
}

run_tests