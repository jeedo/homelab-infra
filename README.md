# homelab-infra
Opentofu for my homelab


# Setup

1. Install pre-commit as a uv tool
```
uv tool install pre-commit --with pre-commit-uv
pre-commit install
```



Run the pre-commit hooks by running:
```
pre-commit run -a
````

if there are no changes it might be beause you forgot to stage the changes with `git add .``

If `tofu_fmt` fails but reports files were modified. Just run `pre-commit run -a` again to apply the formatting changes.