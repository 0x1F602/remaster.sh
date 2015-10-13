. 'functions/print_help.sh'

if [[ -z $CLI_ARGUMENTS ]]; then
    print_help 
    exit
fi

optspec=":-:"
ARG_LIST=($CLI_ARGUMENTS)

while getopts "$optspec" optchar $CLI_ARGUMENTS; do
    case "${optchar}" in
        -)
            case "${OPTARG}" in
                iniso)
                    ORIGINAL_ISO_NAME="${ARG_LIST[$OPTIND-1]}"; OPTIND=$(( $OPTIND + 1 ))
                    ;;
                iniso=*)
                    ORIGINAL_ISO_NAME=${OPTARG#iniso=}
                    ;;
                outiso)
                    NEW_ISO_NAME="${ARG_LIST[$OPTIND-1]}"; OPTIND=$(( $OPTIND + 1 ))
                    ;;
                outiso=*)
                    NEW_ISO_NAME=${OPTARG#outiso=}
                    ;;
                entry)
                    ISOTASK="${ARG_LIST[$OPTIND-1]}"; OPTIND=$(( $OPTIND + 1 ))
                    ;;
                entry=*)
                    ISOTASK=${OPTARG#entry=}
                    ;;
                *)
                    if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                        echo "Unknown option --${OPTARG}" >&2
                    fi
                    ;;
            esac;;
        *)
            if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                echo "Non-option argument: '-${OPTARG}'" >&2
            fi
            ;;
    esac
done

if [[ -z $ORIGINAL_ISO_NAME || -z $NEW_ISO_NAME ]]; then
    print_help 
    exit
fi
