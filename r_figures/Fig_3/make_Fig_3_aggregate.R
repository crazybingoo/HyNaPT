repo_hint <- Sys.getenv("HYNAPT_REPO_ROOT", unset = "")
if (nzchar(repo_hint)) source(file.path(repo_hint, "r_figures", "common", "plot_utils.R")) else source(file.path(dirname(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)[1]))), "common", "plot_utils.R"))
d <- read_public_sheet("Fig_3")
d$region <- factor(d$region, levels = c("NIZ", "PZ", "SOZ"))
d$metric <- factor(d$metric, levels = c("sensitivity", "entropy", "betweenness"), labels = c("Sensitivity", "Transition entropy", "Betweenness"))

p <- ggplot(d, aes(estimate, region, colour = region)) +
  geom_vline(xintercept = 0, colour = hynapt_palette[["light_grey"]], linetype = 2, linewidth = 0.4) +
  geom_errorbar(aes(xmin = ci_low, xmax = ci_high), width = 0, orientation = "y", linewidth = 0.45) +
  geom_point(shape = 21, fill = "white", size = 2.1, stroke = 0.45) +
  facet_wrap(~metric, scales = "free_x", nrow = 1) +
  scale_colour_manual(values = c(NIZ = hynapt_palette[["grey"]], PZ = hynapt_palette[["teal"]], SOZ = hynapt_palette[["purple"]])) +
  labs(x = "Ictal - pre-ictal change", y = NULL) +
  theme_hynapt() + theme(legend.position = "none")
save_public_plot(p, "Fig_3_aggregate", 180, 65)
