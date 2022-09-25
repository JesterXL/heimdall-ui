dat_rev="$(git rev-parse HEAD^1)"
echo "Pushing previous commit to main-minus-one branch for instant rollback: $dat_rev"
# git push git@gitlab.com:some/path/project.git "$(git rev-parse HEAD^1)":refs/heads/main-minus-one
git clone https://gitlab.com/path/project.git
git push https://gitlab.com/path/project.git "$(git rev-parse HEAD^1)":refs/heads/main-minus-one
