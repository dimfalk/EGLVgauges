% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_rv_meta.R
\name{get_rv_meta}
\alias{get_rv_meta}
\title{Get (extended) metadata for selected RV gauges}
\usage{
get_rv_meta(x = NULL)
}
\arguments{
\item{x}{Sf object containing gauges to be used for subsequent queries,
as provided by \code{get_rv_gauges()}.}
}
\value{
Tibble containing metadata.
}
\description{
Get (extended) metadata for selected RV gauges
}
\examples{
\dontrun{
gauge <- get_rv_gauges() |> dplyr::filter(station_nr == "2762715000100")
get_rv_meta(gauge)

gauges <- get_rv_gauges() |> dplyr::filter(parameter_name == "Wasserstand")
get_rv_meta(gauges)
}
}
\seealso{
\code{\link[=get_rv_gauges]{get_rv_gauges()}}
}
