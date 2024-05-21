---
html_theme.sidebar_secondary.remove: true
---

What can PandABlocks do?
-------------------------

PandABlocks is a framework enabling a number of functional [Block](reference/glossary.rst#Block) instances to be written and loaded to an FPGA, with their parameters (including their connections to other Blocks) changed at runtime. It allows flexible triggering and processing systems to be created, by users who are unfamiliar with writing FPGA firmware.

![image](fpga_arch.png)

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
Extending the functionality of, and generating new blocks for, a PandABlocks device.
:::

:::{grid-item-card} {material-regular}`menu_book;2em`
```{toctree}
:maxdepth: 2
reference
```
+++
General reference documentation, and working on the core autogeneration framework.
:::

::::
:::{dropdown} Available Blocks
```{toctree}
:maxdepth: 2
blocks.rst
```
:::
