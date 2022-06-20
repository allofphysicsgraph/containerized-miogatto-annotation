
# Dockerfile for <https://github.com/wtsnjp/MioGatto>

How to use:

```bash
make docker_build
make docker_live
```
From within the container, suppose the file `/scratch/file_more.tex` contains
```tex
\documentclass{article}
\usepackage{amsmath}
\begin{document}
hello $x$
\begin{equation}
x+2
\end{equation}
\end{document}
```
Then the command
```bash
latexmlc --preload=[nobibtex,ids,mathlexemes,localrawstyles]latexml.sty \
         --format=html5 --pmml --cmml --mathtex --nodefaultresources \
         --dest=out.html /scratch/file_more.tex 
```
produces the output
```bash
latexmlc (LaTeXML version 0.8.6)
processing started Mon Jun 20 19:27:51 2022
Conversion complete: No obvious problems
Post-processing complete: No obvious problems
Status:conversion:0
```

The next step is to run `python -m tools.preprocess /scratch/out.html` which relies on content in `/opt/MioGatto`
```bash
export PYTHONPATH="$PYTHONPATH:/opt/MioGatto"
python -m tools.preprocess /scratch/out.html 
```
which produces the output
```bash
tools.preprocess INFO: Begin to preprocess Paper "out"
#indentifiers: 1
#occurences: 2
mi attributes: xref, id
tools.preprocess INFO: Writing preprocessed HTML to sources/out.html
tools.preprocess INFO: Writing initialized anno template to data/out_anno.json
tools.preprocess INFO: Writing initialized mcdict template to data/out_mcdict.json
```

Because the HTML file is named "out", pass that to the analyzer script
```bash
python -m tools.analyzer out
```
_Where I'm currently stuck, 1 of 2_: output is
```bash
RuntimeError: module compiled against API version 0xf but this version of numpy is 0xd
Traceback (most recent call last):
  File "/usr/lib/python3.9/runpy.py", line 197, in _run_module_as_main
    return _run_code(code, main_globals, None,
  File "/usr/lib/python3.9/runpy.py", line 87, in _run_code
    exec(code, run_globals)
  File "/opt/MioGatto/tools/analyzer.py", line 5, in <module>
    import seaborn as sns
  File "/usr/local/lib/python3.9/dist-packages/seaborn/__init__.py", line 2, in <module>
    import matplotlib as mpl
  File "/usr/local/lib/python3.9/dist-packages/matplotlib/__init__.py", line 207, in <module>
    _check_versions()
  File "/usr/local/lib/python3.9/dist-packages/matplotlib/__init__.py", line 192, in _check_versions
    from . import ft2font
ImportError: numpy.core.multiarray failed to import
```

_Where I'm currently stuck, 2 of 2_: I don't understand how to launch the web client
