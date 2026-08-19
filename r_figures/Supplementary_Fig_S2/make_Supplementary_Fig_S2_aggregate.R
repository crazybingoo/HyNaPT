repo_hint <- Sys.getenv("HYNAPT_REPO_ROOT", unset = "")
if (nzchar(repo_hint)) source(file.path(repo_hint, "r_figures", "common", "plot_utils.R")) else source(file.path(dirname(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)[1]))), "common", "plot_utils.R"))
d <- read_public_sheet("Supp_Fig_S2")
make_panel <- function(panel_name, tag, colour) {
  x <- subset(d, panel == panel_name)
  x$display <- factor(paste(x$target, x$contrast, sep = " | "), levels = rev(paste(x$target, x$contrast, sep = " | ")))
  ggplot(x, aes(estimate, display)) +
    geom_vline(xintercept = 0, colour = hynapt_palette[["light_grey"]], linetype = 2, linewidth = 0.4) +
    geom_errorbar(aes(xmin = ci_low, xmax = ci_high), width = 0, orientation = "y", colour = colour, linewidth = 0.4) +
    geom_point(shape = 21, fill = "white", colour = colour, size = 1.9) +
    labs(tag = tag, x = "Aggregate paired effect", y = NULL) + theme_hynapt()
}
p_a <- make_panel("a", "a", hynapt_palette[["purple"]])
p_b <- make_panel("b", "b", hynapt_palette[["teal"]])
p_c <- make_panel("c", "c", hynapt_palette[["pink"]])
save_public_plot(p_a + p_b + p_c + plot_layout(widths = c(1, 1.2, 1)), "Supplementary_Fig_S2_aggregate", 180, 118)
