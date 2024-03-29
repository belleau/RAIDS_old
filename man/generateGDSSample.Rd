% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gdsWrapper.R
\encoding{UTF-8}
\name{generateGDSSample}
\alias{generateGDSSample}
\title{Initialization of the section related to the sample
information in the \code{gds} file.}
\usage{
generateGDSSample(gds, pedDF, listSamples = NULL)
}
\arguments{
\item{gds}{a \code{gds}.}

\item{pedDF}{a \code{data.frame} containing the information related to the
sample. It must have those columns: "sample.id", "Name.ID", "sex",
"pop.group", "superPop" and "batch". The unique id of pedDF
is Name.ID and the row.name is Name.ID too.}

\item{listSamples}{a \code{array} with the sample from pedDF to keep}
}
\value{
the a \code{array} with the sample from pedDF keept
}
\description{
This function initializesthe section related to the sample
information in the \code{gds} file. The information is extracted from
the \code{data.frame} \code{pedDF} passed to the function.
}
\examples{

# TODO
gds <- "Demo GDS TODO"

}
\author{
Pascal Belleau, Astrid Deschênes and Alexander Krasnitz
}
\keyword{internal}
