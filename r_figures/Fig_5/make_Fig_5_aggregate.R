repo_hint <- Sys.getenv("HYNAPT_REPO_ROOT", unset = "")
if (nzchar(repo_hint)) source(file.path(repo_hint, "r_figures", "common", "plot_utils.R")) else source(file.path(dirname(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)[1]))), "common", "plot_utils.R"))
d <- read_public_sheet("Fig_5")

b <- subset(d, panel == "b")
b$series <- factor(b$series, levels = rev(c("HyNaPT", "Attribute permutation", "Topology-only")))
c <- subset(d, panel == "c")
c$series <- factor(c$series, levels = rev(c("vs attribute perm.", "vs topology only")))
dd <- subset(d, panel == "d" & series != "All stages")
dd$series <- factor(dd$series, levels = c("Pre", "Early", "Middle", "Late", "Post"))

p_b <- ggplot(b, aes(estimate, series)) + interval_layer(hynapt_palette[["purple"]]) +
  labs(tag = "b", x = "Propagation difference", y = NULL) + theme_hynapt()
p_c <- ggplot(c, aes(estimate, series)) +
  geom_vline(xintercept = 0, colour = hynapt_palette[["light_grey"]], linetype = 2, linewidth = 0.4) +
  interval_layer(hynapt_palette[["pink"]]) +
  labs(tag = "c", x = "HyNaPT gain", y = NULL) + theme_hynapt()
p_d <- ggplot(dd, aes(series, estimate, group = 1)) +
  geom_hline(yintercept = 0, colour = hynapt_palette[["light_grey"]], linetype = 2, linewidth = 0.4) +
  geom_line(colour = hynapt_palette[["teal"]], linewidth = 0.45) +
  geom_errorbar(aes(ymin = ci_low, ymax = ci_high), width = 0.14, colour = hynapt_palette[["teal"]], linewidth = 0.45) +
  geom_point(shape = 21, fill = "white", colour = hynapt_palette[["teal"]], size = 2.1) +
  labs(tag = "d", x = NULL, y = "Efficiency gain") + theme_hynapt()
save_public_plot(p_b + p_c + p_d + plot_layout(widths = c(1, 1, 1.25)), "Fig_5_aggregate", 180, 72)
