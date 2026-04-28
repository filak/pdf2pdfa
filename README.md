# pdf2pdfa
Batch script to convert PDF to PDF/A using Ghostscript

Supports:
- PDF/A-1b
- PDF/A-2b
- PDF/A-3b  

## Installation

Install **Ghostscript 64 bit** - download from https://www.ghostscript.com/releases/gsdnld.html

Copy the batchfile **pdf2pdfa.bat** to the Ghostscript \\bin directory.

Make sure the \\bin dir is added to the PATH env variable. 

## Usage

     pdf2pdfa <PDF/A version> <file|dir> [output_dir - default: _out]

### Parameters

- `PDF/A version`
  - `1` = PDF/A-1b
  - `2` = PDF/A-2b
  - `3` = PDF/A-3b

- `file|dir`
  - Single PDF file OR directory with PDFs

- `output_dir` (optional)
  - Output folder
  - Default: `_out`
