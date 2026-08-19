repo_hint <- Sys.getenv("HYNAPT_REPO_ROOT", unset = "")
if (nzchar(repo_hint)) source(file.path(repo_hint, "r_figures", "common", "plot_utils.R")) else source(file.path(dirname(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)[1]))), "common", "plot_utils.R"))
d <- read_public_sheet("Supp_Fig_S1")
d$label <- factor(d$label, levels = rev(d$label))
p <- ggplot(d, aes(estimate, label, shape = is_reference)) +
  geom_errorbar(aes(xmin = ci_low, xmax = ci_high), width = 0, orientation = "y", colour = hynapt_palette[["grey"]], linewidth = 0.4) +
  geom_point(size = 2, stroke = 0.5, fill = "white", colour = hynapt_palette[["purple"]]) +
  facet_grid(family ~ ., scales = "free_y", space = "free_y", switch = "y") +
  scale_shape_manual(values = c(`FALSE` = 16, `TRUE` = 21), guide = "none") +
  labs(x = "Mean AP", y = NULL) + theme_hynapt() +
  theme(strip.placement = "outside", strip.background = element_blank(),
        strip.text.y.left = element_text(angle = 0, hjust = 1, size = 8))
save_public_plot(p, "Supplementary_Fig_S1_aggregate", 150, 150)
