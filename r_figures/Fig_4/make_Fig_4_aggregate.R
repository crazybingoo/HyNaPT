repo_hint <- Sys.getenv("HYNAPT_REPO_ROOT", unset = "")
if (nzchar(repo_hint)) source(file.path(repo_hint, "r_figures", "common", "plot_utils.R")) else source(file.path(dirname(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)[1]))), "common", "plot_utils.R"))
d <- read_public_sheet("Fig_4")
d$stage <- factor(d$stage, levels = c("Early", "Middle", "Late", "Post"))

make_panel <- function(metric_name, tag, y_label, colour) {
  x <- subset(d, metric == metric_name)
  ggplot(x, aes(stage, estimate)) +
    geom_hline(yintercept = 0, colour = hynapt_palette[["light_grey"]], linetype = 2, linewidth = 0.4) +
    geom_errorbar(aes(ymin = ci_low, ymax = ci_high), width = 0.14, linewidth = 0.45, colour = colour) +
    geom_point(shape = 21, fill = "white", colour = colour, size = 2.2, stroke = 0.45) +
    labs(tag = tag, x = NULL, y = y_label) + theme_hynapt()
}
p_b <- make_panel("adjacent_ARI", "b", expression(Delta*" adjacent-window ARI"), hynapt_palette[["teal"]])
p_c <- make_panel("module_entropy", "c", expression(Delta*" module entropy"), hynapt_palette[["purple"]])
save_public_plot(p_b + p_c, "Fig_4_aggregate", 180, 72)
