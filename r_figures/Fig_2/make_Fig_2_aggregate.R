repo_hint <- Sys.getenv("HYNAPT_REPO_ROOT", unset = "")
if (nzchar(repo_hint)) source(file.path(repo_hint, "r_figures", "common", "plot_utils.R")) else source(file.path(dirname(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)[1]))), "common", "plot_utils.R"))

d <- read_public_sheet("Fig_2")
e <- subset(d, panel == "e")
e$stage <- factor(e$stage, levels = c("Pre-ictal", "Ictal", "Post-ictal"))
e$region <- factor(e$region, levels = c("SOZ", "PZ", "NIZ"))
f <- subset(d, panel == "f")
f$series <- factor(f$series, levels = rev(c("HyNaPT", "Pairwise PLV", "Topology only", "Attribute permutation")))
g <- subset(d, panel == "g" & outcome == "Normalized AP lift")
h <- subset(d, panel == "h")

p_e <- ggplot(e, aes(stage, estimate, fill = region)) +
  geom_col(position = position_dodge(width = 0.78), width = 0.68, colour = "white", linewidth = 0.2) +
  geom_errorbar(
    aes(ymin = pmax(0, estimate - sd), ymax = pmin(1, estimate + sd)),
    position = position_dodge(width = 0.78), width = 0.12, linewidth = 0.35
  ) +
  scale_fill_manual(values = c(
    SOZ = hynapt_palette[["purple"]],
    PZ = hynapt_palette[["teal"]],
    NIZ = hynapt_palette[["grey"]]
  )) +
  labs(tag = "e", x = NULL, y = "Regional node activity", fill = NULL) +
  coord_cartesian(ylim = c(0, 0.8)) + theme_hynapt()

p_f <- ggplot(f, aes(estimate, series)) + interval_layer(hynapt_palette[["purple"]]) +
  labs(tag = "f", x = "Average precision", y = NULL) + xlim(0.45, 0.92) + theme_hynapt()

p_g <- ggplot(g, aes(estimate, 1)) +
  geom_vline(xintercept = 0, colour = hynapt_palette[["light_grey"]], linetype = 2, linewidth = 0.4) +
  interval_layer(hynapt_palette[["teal"]]) +
  annotate(
    "text", x = 0.72, y = 1.08, hjust = 1, size = 2.4,
    label = sprintf("8/10 positive; two-sided P = %.4f", g$p_value[[1]])
  ) +
  scale_y_continuous(NULL, breaks = NULL) +
  coord_cartesian(xlim = c(-0.05, 0.75)) +
  labs(tag = "g", x = "Normalized AP lift", y = NULL) + theme_hynapt()

p_h <- ggplot(h, aes(estimate, 1)) +
  geom_segment(aes(x = reference, xend = reference, y = 0.7, yend = 1.3), colour = hynapt_palette[["light_grey"]], linetype = 2) +
  interval_layer(hynapt_palette[["pink"]]) +
  facet_wrap(~outcome, scales = "free_x", ncol = 1) +
  scale_y_continuous(NULL, breaks = NULL) +
  labs(tag = "h", x = "Estimate", y = NULL) + theme_hynapt()

figure <- (p_e | p_f) / (p_g | p_h) + plot_layout(heights = c(1.08, 1))
save_public_plot(figure, "Fig_2_aggregate", 180, 100)
