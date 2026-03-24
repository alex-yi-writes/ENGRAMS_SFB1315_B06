# plot normalised MD values from matlab export
# you need: tidyverse, ggplot2

library(tidyverse)
library(ggplot2)

# import CSV from MATLAB
md_data <- read_csv('/Users/alex/Dropbox/paperwriting/1315/data/MD_normalised_for_plotting.csv')

# more detailed condition categorization to make sense
md_data <- md_data %>%
  mutate(
    Phase_Label = factor(Phase_Label, 
                         levels = c('BSL', 'Early RCG', 'Late RCG', 'Recombi RCG')),
    Condition = factor(Condition, levels = c('Control', 'Experimental')),
    # extract ids
    Subject_Num = as.numeric(gsub('sub-', '', Subject)),
    # more categories for experimental subjects
    Subtype = case_when(
      Condition == 'Control' ~ 'Control',
      Condition == 'Experimental' & (Subject_Num %% 2 == 1) ~ 'Emotional',
      Condition == 'Experimental' & (Subject_Num %% 2 == 0) ~ 'Neutral'
    ),
    Subtype = factor(Subtype, levels = c('Control', 'Emotional', 'Neutral'))
  )

# def colour palette: grey for control, warm for emotional, cool for neutral
colour_palette <- c(
  'Control' = '#808080',
  'Emotional' = '#FF6633',
  'Neutral' = '#3366FF'
)

############### SIGNIFICANCE TESTING: Control vs Experimental #################
# calc sig between ctrl and exp at each phase and roi
sig_data <- md_data %>%
  group_by(ROI, Phase_Label) %>%
  nest() %>%
  mutate(
    t_test = map(data, ~{
      control_vals <- filter(.x, Condition == 'Control')$MD_Normalised
      experimental_vals <- filter(.x, Condition == 'Experimental')$MD_Normalised
      
      if (length(control_vals) > 1 && length(experimental_vals) > 1) {
        tryCatch({
          test_result <- t.test(control_vals, experimental_vals)
          data.frame(
            p_value = test_result$p.value,
            t_stat = test_result$statistic
          )
        }, error = function(e) {
          # bugged... temp solution: return NA if t-test fails
          data.frame(
            p_value = NA,
            t_stat = NA
          )
        })
      } else {
        data.frame(
          p_value = NA,
          t_stat = NA
        )
      }
    })
  ) %>%
  unnest(t_test) %>%
  select(ROI, Phase_Label, p_value, t_stat) %>%
  mutate(
    sig_symbol = case_when(
      p_value < 0.01 ~ '**',
      p_value < 0.05 ~ '*',
      p_value < 0.1 ~ 'o',
      TRUE ~ ''
    )
  )

# summary
summary_by_subtype <- md_data %>%
  group_by(ROI, Phase_Label, Subtype) %>%
  summarise(
    mean_md = mean(MD_Normalised, na.rm = TRUE),
    sd_md = sd(MD_Normalised, na.rm = TRUE),
    n = sum(!is.na(MD_Normalised)),
    se_md = sd_md / sqrt(n),
    .groups = 'drop'
  )

# calc y-pos for sig labels
# first calc the upper limit of the SE bars for each phase and ROI
sig_positions <- summary_by_subtype %>%
  group_by(ROI, Phase_Label) %>%
  summarise(
    max_se_top = max(mean_md + se_md, na.rm = TRUE),
    .groups = 'drop'
  ) %>%
  mutate(sig_y = max_se_top * 1.05)  # pos 5% above the top of SE bar

# prep sig labels for plotting
sig_for_plot <- sig_data %>%
  left_join(sig_positions, by = c('ROI', 'Phase_Label')) %>%
  filter(sig_symbol != '')

# summary
summary_data <- md_data %>%
  group_by(ROI, Phase_Label, Condition) %>%
  summarise(
    mean_md = mean(MD_Normalised, na.rm = TRUE),
    sd_md = sd(MD_Normalised, na.rm = TRUE),
    n = sum(!is.na(MD_Normalised)),
    se_md = sd_md / sqrt(n),
    .groups = 'drop'
  )

summary_by_subtype <- md_data %>%
  group_by(ROI, Phase_Label, Subtype) %>%
  summarise(
    mean_md = mean(MD_Normalised, na.rm = TRUE),
    sd_md = sd(MD_Normalised, na.rm = TRUE),
    n = sum(!is.na(MD_Normalised)),
    se_md = sd_md / sqrt(n),
    .groups = 'drop'
  )

############### CREATE COMBINED PLOT WITH SIGNIFICANCE STARS ############### 
plot_combined <- ggplot(md_data, aes(x = Phase_Label, y = MD_Normalised, colour = Subtype)) +
  
  # indiv datapoint lines with low transparency
  #geom_line(aes(group = Subject, colour = Subtype), alpha = 0.2, linewidth = 0.5) +
  #geom_point(aes(colour = Subtype), alpha = 0.3, size = 1.8) +
  
  # mean line
  geom_line(data = summary_by_subtype, aes(x = Phase_Label, y = mean_md, 
                                           group = Subtype,
                                           linetype = Subtype,
                                           colour = Subtype),
            linewidth = 0.8, alpha = 0.95) +
  geom_point(data = summary_by_subtype, aes(x = Phase_Label, y = mean_md, colour = Subtype),
             size = 2, alpha = 0.9) +
  
  # errorbars
  geom_errorbar(data = summary_by_subtype, aes(x = Phase_Label, y = mean_md,
                                               ymin = mean_md - se_md,
                                               ymax = mean_md + se_md,
                                               colour = Subtype),
                width = 0.1, linewidth = 0.7, alpha = 0.85) +
  
  # sigstars
  geom_text(data = sig_for_plot, aes(x = Phase_Label, y = sig_y, 
                                     label = sig_symbol, colour = NULL),
           size = 6, vjust = -0.5, colour = 'black', fontface = 'bold', 
           show.legend = FALSE) +
  
  # ref line at bsl
  geom_hline(yintercept = 1, linetype = 'dotted', colour = 'grey50', linewidth = 0.7) +
  
  # facets for each roi
  facet_wrap(~ ROI, scales = 'free_y', nrow = 4, ncol = 2) +
  
  # formats
  scale_colour_manual(values = colour_palette,
                      labels = c('Control' = 'Control',
                                 'Emotional' = 'Emotional',
                                 'Neutral' = 'Neutral')) +
  scale_linetype_manual(values = c('Control' = 'dashed', 
                                   'Emotional' = 'solid',
                                   'Neutral' = 'solid'),
                        labels = c('Control' = 'Control',
                                   'Emotional' = 'Emotional',
                                   'Neutral' = 'Neutral')) +
  
  labs(
    title = 'Mean Diffusivity Normalised to Baseline',
    #subtitle = 'indiv trajectories (faint lines, colour-coded by condition) with group means +- SE\n o p<0.1, * p<0.05, ** p<0.01',
    x = 'Phase',
    y = 'MD (Normalised to Baseline)',
    colour = 'Condition',
    linetype = 'Condition'
  ) +
  
  theme_minimal() +
  theme(
    axis.title = element_text(size = 12, face = 'bold'),
    strip.text = element_text(size = 12, face = 'bold'),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.spacing.x = unit(1.2, 'cm'),  # up the horizontal spacing between facets
    panel.spacing.y = unit(1.7, 'cm'),  # up the vertical spacing between facets
    legend.position = 'bottom',
    legend.box = 'horizontal',
    legend.margin = margin(t = 10),
    plot.title = element_text(size = 14, face = 'bold', hjust = 0.5),
    plot.subtitle = element_text(size = 10, hjust = 0.5, colour = 'grey40'),
    axis.text = element_text(size = 10)
  )

ggsave('MD_normalised_combined.png', plot_combined, width = 16, height = 12, dpi = 300)
ggsave('MD_normalised_combined.pdf', plot_combined, width = 16, height = 12)

print(plot_combined)

# print stats
cat('\n********************************\n')
cat('SUMMARY STATISTICS\n')
cat('********************************\n')
print(summary_data)

cat('\n********************************\n')
cat('STATISTICAL SIGNIFICANCE\n')
cat('(Control vs Experimental)\n')
cat('********************************\n')
cat('Significance levels: * p<0.05, ** p<0.01, *** p<0.001\n\n')
print(sig_data %>% arrange(ROI, Phase_Label))

cat('\n********************************\n')
cat('SIGNIFICANT RESULTS (p < 0.05)\n')
cat('********************************\n')
cat('number of significant comparisons:', nrow(sig_for_plot), '\n\n')
if (nrow(sig_for_plot) > 0) {
  print(sig_for_plot %>% select(ROI, Phase_Label, p_value, sig_symbol) %>% arrange(ROI, Phase_Label))
} else {
  cat('no significant differences found at p < 0.05\n')
}
