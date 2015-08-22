function source_env {
    [[ -f "$HELPER_DIR/env" ]] && source "$HELPER_DIR/env"
}

function current_path {
    if [[ ! $0 =~ ^\./ ]]; then 
        curpath=$(dirname $0)
        pushd $curpath >/dev/null
        curpath=$(pwd -P)
        popd >/dev/null
    else
        curpath=$(pwd -P)
    fi
    echo -n $curpath
}

function current_branch {
    CURRENT_BRANCH=$(git branch|perl -ne 'print "$1\n" if(/^\*\s(.*)/)')
    echo -n $CURRENT_BRANCH
}

function remote_branch {
    REMOTE_BRANCH=$(git branch -vv|perl -ne 'print "$1\n" if(/^\*.*\[(.*?)[:\]].*/)')
    echo -n $REMOTE_BRANCH
}

function branch_state {
    echo -n $(git branch --list $(current_branch) -vv | perl -ne 'print "$1\n" if(/^\*?(.*\[.*\])/)')
}

function branch_behind_remote {
    if git status | egrep --color=never 'Your branch.*(behind|diverged)' &>/dev/null; then
        return 0
    fi
    return 1
}

function remote_branch_defiend {
    if [[ -z $REMOTE_BRANCH ]]; then
        echo "$CURRENT_BRANCH is not set up to track a remote branch"
        echo "You should run:"
        echo "git branch $CURRENT_BRANCH --set-upstream <remote>/<branch>"
        return 1
    fi
    return 0
}

function suggest {
    CURRENT_BRANCH=$(current_branch)
    REMOTE_BRANCH=$(remote_branch)

    if ! remote_branch_defiend; then
        popd >/dev/null
        return 1
    fi 
    
    #echo "Producion branch: $PROD_BRANCH"
    echo $(branch_state)
    echo You should probably:
    echo "  git log --stat ..$REMOTE_BRANCH"
    echo "  git rebase --preserve-merges $REMOTE_BRANCH"
    #if [[ $CURRENT_BRANCH == $PROD_BRANCH ]]; then
    #    echo "  git merge $REMOTE_BRANCH"
    #else
    #    echo "  git rebase $REMOTE_BRANCH"
    #fi
}

function merge_menu {
    echo -n "View log? "; read -n1 REPLY
    [[ $REPLY == 'y' ]] && git log --stat ..$REMOTE_BRANCH
    echo

    while true; do
        #echo -n "Merge[m] Rebase[r] Interactive rebase[ri] Cancel[c]? "; read REPLY
        echo -n "Rebase[r] Interactive rebase[ri] Cancel[c]? "; read REPLY

        case $REPLY in
            'c' )
                break
                ;;
            # 'm' )
            #     git merge $REMOTE_BRANCH
            #     break
            #     ;;
            'r' )
                git rebase --preserve-merges $REMOTE_BRANCH
                break
                ;;
            'ri' )
                git rebase --interactive $REMOTE_BRANCH
                break
                ;;
        esac
    done
}

function update_project {
    PROJECT_DIR=$1
    if [[ -z $PROJECT_DIR ]]; then
        echo "Specify a project directory"
        return 1
    fi
    pushd $PROJECT_DIR >/dev/null || return 1
    if ! git status >/dev/null; then
       popd >/dev/null
       return 1
   fi

    PROJECT_NAME=$(basename $(pwd))
    CURRENT_BRANCH=$(current_branch)
    REMOTE_BRANCH=$(remote_branch)

    if [[ -z $CURRENT_BRANCH ]]; then
        echo "Could not figure out current branch name" 
        popd >/dev/null
        return 1
    fi

    echo "Project '$PROJECT_NAME' on branch '$CURRENT_BRANCH'"

    if ! remote_branch_defiend; then
        popd >/dev/null
        return 1
    fi 

    git remote update

    if branch_behind_remote; then
    #if true; then
        suggest
        if [[ $INTERACTIVE == 'true' ]]; then
            merge_menu
        fi
    else
        echo "$CURRENT_BRANCH -> $REMOTE_BRANCH (up to date)"
    fi
    popd >/dev/null
}

# Default name for production branch
# Override with: export PROD_BRANCH=<branch_name>
export PROD_BRANCH=${PROD_BRANCH:='master'}
export HELPER_DIR=$(current_path)
source_env


