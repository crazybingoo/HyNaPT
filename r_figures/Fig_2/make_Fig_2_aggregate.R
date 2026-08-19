repo_hint <- Sys.getenv("HYNAPT_REPO_ROOT", unset = "")
if (nzchar(repo_hint)) source(file.path(repo_hint, "r_figures", "common", "plot_utils.R")) else source(file.path(dirname(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)[1]))), "common", "plot_utils.R"))

d <- read_public_sheet("Fig_2")
f <- subset(d, panel == "f")
f$series <- factor(f$series, levels = rev(c("HyNaPT", "Pairwise-PLV", "Hypergraph-topology", "HyNaPT-permuted")))
g <- subset(d, panel == "g")
g$comparator <- factor(g$comparator, levels = rev(g$comparator))
h <- subset(d, panel == "h")

p_f <- ggplot(f, aes(estimate, series)) + interval_layer(hynapt_palette[["purple"]]) +
  labs(tag = "f", x = "Average precision", y = NULL) + xlim(0.45, 0.92) + theme_hynapt()
p_g <- ggplot(g, aes(estimate, comparator)) +
  geom_vline(xintercept = 0, colour = hynapt_palette[["light_grey"]], linetype = 2, linewidth = 0.4) +
  interval_layer(hynapt_palette[["teal"]]) +
  labs(tag = "g", x = expression(Delta*"AP (HyNaPT - comparator)"), y = NULL) + theme_hynapt()
p_h <- ggplot(h, aes(estimate, 1)) +
  geom_segment(aes(x = reference, xend = reference, y = 0.7, yend = 1.3), colour = hynapt_palette[["light_grey"]], linetype = 2) +
  interval_layer(hynapt_palette[["pink"]]) +
  facet_wrap(~outcome, scales = "free_x", ncol = 1) +
  scale_y_continuous(NULL, breaks = NULL) +
  labs(tag = "h", x = "Estimate", y = NULL) + theme_hynapt()

figure <- p_f + p_g + p_h + plot_layout(widths = c(1, 1.2, 1))
save_public_plot(figure, "Fig_2_aggregate", 180, 72)
