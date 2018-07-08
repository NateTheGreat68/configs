#!/bin/bash
#

set -e
set -o pipefail

function docker-build-print_usage {
    echo "Usage: $1 [options] image_name tag [additional_tags]"
    echo "  options:"
    echo "    -r            Run image after building."
    echo "    -e            Exec image using /bin/bash."
    echo "    -E command    Exec image using command."
    echo "    -p username   Push built image to username/image_name (using all"
    echo "                  given tags individually)."
}

function docker-build {
    # Parse all the options out
    next_option=""
    run_image=0
    dockerhub_username=""
    exec_command=""
    image_name=""
    tag=""
    declare -a more_tags
    for argument in "${@:1}" ; do
        if [[ $argument =~ ^-[preE]+$ ]] ; then
            for (( i=1; i<${#argument}; i++ )) ; do
                case ${argument:$i:1} in
                    p)
                        if [ "$next_option" != "" ] ; then
                            docker-build-print_usage
                            exit 1
                        fi
                        next_option="dockerhub_username"
                        ;;
                    E)
                        if [ "$next_option" != "" ] ; then
                            docker-build-print_usage
                            exit 1
                        fi
                        next_option="exec_command"
                        ;;
                    r)
                        run_image=1
                        ;;
                    e)
                        run_image=1
                        exec_command="/bin/bash"
                        ;;
                esac
            done
        elif [ "$next_option" != "" ] ; then
            case $next_option in
                dockerhub_username)
                    dockerhub_username=$argument
                    next_option=""
                    ;;
                exec_command)
                    exec_command=$argument
                    next_option=""
                    ;;
            esac
        elif [ "$image_name" = "" ] ; then
            image_name=$argument
        elif [ "$tag" = "" ] ; then
            tag=$argument
        else
            more_tags[${#more_tags[*]}]=$argument
        fi
    done
    # Make sure we're not missing anything
    if [ "$next_option" != "" ] ; then
        docker-build-print_usage
        exit 1
    fi
    if [ "$image_name" = "" ] || [ "$tag" = "" ]  ; then
        docker-build-print_usage
        exit 1
    fi

    # Build
    echo "Building ${image_name}:${tag}..."
    image_id=$(docker build -t "${image_name}:${tag}" . | tee /dev/tty | \
        sed -nE 's/^Successfully built ([0-9a-f]+)$/\1/p')

    # Run?
    if [ "$run_image" -eq 1 ] ; then
        echo "Running container..."
        container_id=$(docker run -d ${image_name}:${tag})
    fi

    # Exec?
    if [ "$exec_command" != "" ] ; then
        echo "Executing container..."
        docker exec -it $container_id "$exec_command"
    fi

    # Push?
    if [ "$dockerhub_username" != "" ] ; then
        echo "Pushing image..."
        docker tag "${image_name}:${tag}" \
            "${dockerhub_username}/${image_name}:${tag}"
        docker push "${dockerhub_username}/${image_name}:${tag}"
        for (( i=0; i<${#more_tags[*]}; i++ )) ; do
            docker tag "${image_name}:${tag}" \
                "${dockerhub_username}/${image_name}:${more_tags[i]}"
            docker push "${dockerhub_username}/${image_name}:${more_tags[i]}"
        done
    fi
}

docker-build ${@:1}
