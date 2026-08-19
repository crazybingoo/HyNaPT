repo_hint <- Sys.getenv("HYNAPT_REPO_ROOT", unset = "")
if (nzchar(repo_hint)) source(file.path(repo_hint, "r_figures", "common", "plot_utils.R")) else source(file.path(dirname(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)[1]))), "common", "plot_utils.R"))
d <- read_public_sheet("Fig_6")
a <- subset(d, panel == "a")
a$label <- factor(a$label, levels = rev(a$label))
b <- subset(d, panel == "b")
b$label <- factor(b$label, levels = b$label)
c <- subset(d, panel == "c")
c$label <- factor(c$label, levels = unique(c$label))

p_a <- ggplot(a, aes(estimate, label, shape = is_reference)) +
  geom_errorbar(aes(xmin = ci_low, xmax = ci_high), width = 0, orientation = "y", colour = hynapt_palette[["grey"]], linewidth = 0.4) +
  geom_point(size = 1.9, stroke = 0.5, fill = "white", colour = hynapt_palette[["purple"]]) +
  facet_grid(group ~ ., scales = "free_y", space = "free_y", switch = "y") +
  scale_shape_manual(values = c(`FALSE` = 16, `TRUE` = 21), guide = "none") +
  labs(tag = "a", x = "Mean AP", y = NULL) + theme_hynapt() +
  theme(strip.placement = "outside", strip.background = element_blank(),
        strip.text.y.left = element_text(angle = 0, hjust = 1, size = 8))
p_b <- ggplot(b, aes(label, estimate, group = 1)) +
  geom_line(colour = hynapt_palette[["teal"]], linewidth = 0.45) +
  geom_errorbar(aes(ymin = ci_low, ymax = ci_high), width = 0.14, colour = hynapt_palette[["teal"]], linewidth = 0.4) +
  geom_point(shape = 21, fill = "white", colour = hynapt_palette[["teal"]], size = 2) +
  labs(tag = "b", x = NULL, y = "Path-visit AP") + theme_hynapt() + theme(axis.text.x = element_text(angle = 35, hjust = 1))
p_c <- ggplot(c, aes(label, estimate, colour = metric, group = metric)) +
  geom_line(linewidth = 0.45) +
  geom_errorbar(aes(ymin = ci_low, ymax = ci_high), width = 0.12, linewidth = 0.4, position = position_dodge(width = 0.15)) +
  geom_point(size = 1.9, position = position_dodge(width = 0.15)) +
  scale_colour_manual(values = c("Node agreement" = hynapt_palette[["purple"]], "Edge Jaccard" = hynapt_palette[["pink"]])) +
  labs(tag = "c", x = NULL, y = "Agreement with argmax", colour = NULL) + theme_hynapt() +
  theme(axis.text.x = element_text(angle = 35, hjust = 1), legend.position = "top")
save_public_plot(p_a + (p_b / p_c) + plot_layout(widths = c(1.5, 1)), "Fig_6_aggregate", 180, 145)
