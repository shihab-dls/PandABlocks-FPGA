---
html_theme.sidebar_secondary.remove: true
---

```{include} ../README.rst
:end-before: <!-- README only content
```


How the documentation is structured
-----------------------------------

Documentation is split into three categories, also accessible from links in the top bar.

<!-- https://sphinx-design.readthedocs.io/en/latest/grids.html -->

::::{grid} 2
:gutter: 4

:::{grid-item-card} {material-regular}`directions;2em`
```{toctree}
:maxdepth: 2
how-to
```
+++
Practical step-by-step guides for the more experienced user.
:::

:::{grid-item-card} {material-regular}`menu_book;2em`
```{toctree}
:maxdepth: 2
reference
```
+++
Technical reference material.
:::

::::
:::{dropdown} Available Blocks
```{toctree}
:maxdepth: 2
blocks.rst
```
:::
