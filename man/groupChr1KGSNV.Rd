% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tools.R
\encoding{UTF-8}
\name{groupChr1KGSNV}
\alias{groupChr1KGSNV}
\title{Merge the genotyping files per chromosome into one file}
\usage{
groupChr1KGSNV(PATHGENOCHR, PATHOUT)
}
\arguments{
\item{PATHGENOCHR}{a \code{character} string representing the path where
the genotyping files for each sample and chromosome are located. The path
must contains sub-directories (one per chromosome) and the genotyping files
must be present in those sub-directories.
The path must exists.}

\item{PATHOUT}{a \code{character} string representing the path where
the merged genotyping files for each sample will be created.
The path must exists.}
}
\value{
The integer \code{0} when successful.
}
\description{
This function merge all the genotyping files associated to one
specific sample into one file. That merged VCF file will be saved in a
specified directory and will have the name of the sample. It will also be
compressed (bzip). The function will merge the
files for all samples present in the input directory.
}
\examples{

## Path to the demo pedigree file is located in this package
data.dir <- system.file("extdata", package="RAIDS")

## TODO

}
\author{
Pascal Belleau, Astrid Deschênes and Alexander Krasnitz
}
