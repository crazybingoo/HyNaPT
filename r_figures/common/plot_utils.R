suppressPackageStartupMessages({
  library(ggplot2)
  library(readxl)
  library(patchwork)
})

hynapt_palette <- c(
  purple = "#7A5AA6",
  teal = "#2A9D8F",
  grey = "#6B7280",
  light_grey = "#C7CBD1",
  pink = "#D77A98",
  navy = "#244A6B"
)

script_path <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  hit <- grep("^--file=", args, value = TRUE)
  if (length(hit) == 0) return(normalizePath(getwd(), winslash = "/"))
  normalizePath(sub("^--file=", "", hit[[1]]), winslash = "/")
}

find_repo_root <- function(start = dirname(script_path())) {
  configured <- Sys.getenv("HYNAPT_REPO_ROOT", unset = "")
  if (nzchar(configured) && file.exists(file.path(configured, "Source_Data.xlsx"))) {
    return(configured)
  }
  current <- normalizePath(start, winslash = "/", mustWork = TRUE)
  repeat {
    if (file.exists(file.path(current, "Source_Data.xlsx"))) return(current)
    parent <- dirname(current)
    if (identical(parent, current)) stop("Could not locate Source_Data.xlsx")
    current <- parent
  }
}

read_public_sheet <- function(sheet) {
  configured <- Sys.getenv("HYNAPT_SOURCE_DATA", unset = "")
  source_file <- if (nzchar(configured)) configured else file.path(find_repo_root(), "Source_Data.xlsx")
  read_excel(source_file, sheet = sheet)
}

theme_hynapt <- function() {
  theme_classic(base_family = "Arial", base_size = 8) +
    theme(
      axis.title = element_text(size = 8, colour = "#20242B"),
      axis.text = element_text(size = 7, colour = "#20242B"),
      strip.text = element_text(size = 8, face = "plain", colour = "#20242B"),
      strip.background = element_blank(),
      legend.title = element_text(size = 8),
      legend.text = element_text(size = 7),
      plot.tag = element_text(size = 8, face = "bold", family = "Arial"),
      plot.tag.position = c(0, 1),
      plot.margin = margin(4, 5, 4, 5),
      panel.spacing = unit(7, "pt")
    )
}

save_public_plot <- function(plot, stem, width_mm = 180, height_mm = 105) {
  configured <- Sys.getenv("HYNAPT_OUTPUT_DIR", unset = "")
  output_dir <- if (nzchar(configured)) configured else file.path(find_repo_root(), "results", "public_figures")
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  base <- file.path(output_dir, stem)
  ggsave(paste0(base, ".pdf"), plot, width = width_mm, height = height_mm, units = "mm", device = cairo_pdf)
  ggsave(paste0(base, ".svg"), plot, width = width_mm, height = height_mm, units = "mm", device = svglite::svglite)
  ggsave(paste0(base, ".png"), plot, width = width_mm, height = height_mm, units = "mm", dpi = 300, bg = "white")
  ggsave(paste0(base, ".tiff"), plot, width = width_mm, height = height_mm, units = "mm", dpi = 300, compression = "lzw", bg = "white")
  invisible(base)
}

interval_layer <- function(colour = hynapt_palette[["purple"]]) {
  list(
    geom_errorbar(aes(xmin = ci_low, xmax = ci_high), width = 0, orientation = "y", linewidth = 0.45, colour = colour),
    geom_point(size = 2.1, shape = 21, stroke = 0.45, fill = "white", colour = colour)
  )
}
