#2022-06-27


## 1. Set up ----

    # point to data locale
    data_locale = "analysis_code/"
    
    # load in the data
    source(paste0(data_locale, "analyze_historic&2022data.R"))


## 2.  Plot percent cover ----
    
    summary_acrossyears %>%
        ggplot(aes(x = survey_year, y = percent_cover)) +
            geom_boxplot() +
            facet_grid(site~qualitative_transect_position) +
            theme_light()
    
    summary_acrossyears %>%
        group_by(survey_year, site, qualitative_transect_position) %>%
        summarize(mean_cover = mean(percent_cover),
                  std_error_cover = std.error(percent_cover)) %>%
            ggplot(aes(x = qualitative_transect_position, y = mean_cover,
                       fill = survey_year)) +
                geom_col(position = position_dodge(.9), color = "black") +
                geom_point(position = position_dodge(.9)) +
                geom_errorbar(aes(ymin = mean_cover - std_error_cover,
                                  ymax = mean_cover + std_error_cover), 
                              width = 0.2, 
                              position = position_dodge(.9)) +
                scale_x_discrete(labels=c("inner_flat" = "Inner Flat", 
                                          "outer_flat" = "Outer Flat")) +
                # scale_y_continuous(limits = c(0,8.25)) +
                scale_fill_manual(values = c("antiquewhite3", "cadetblue4"))+
                facet_wrap(~site) +
                labs(fill = "Survey Year",
                     x = "Reef Flat Position",
                     y = "Mean Percent Cover") +
                theme_pubr(legend = "right") 
    
    
    stat.test_cover = summary_acrossyears %>%
        group_by(site, qualitative_transect_position) %>%
        t_test(percent_cover ~ survey_year) %>% 
        add_significance(p.col = "p", 
                         output.col = "p.adj.signif", 
                         cutpoints = c(0, 0.001, 0.01, 0.05, 1),
                         symbols = c("***", "**", "*", "ns")) %>%
        add_xy_position(x = "qualitative_transect_position", dodge = 0.9) %>%
        mutate(y.position = c(6, 2, 45, 10))
    
    ggbarplot(summary_acrossyears, 
              x = "qualitative_transect_position", y = "percent_cover", 
              fill = "survey_year",
              add = "mean_se",
              position = position_dodge(0.8),
              facet.by = "site") +
        scale_x_discrete(labels=c("inner_flat" = "Inner", 
                                  "outer_flat" = "Outer"),
                         limits = c("inner_flat", "outer_flat")) +
        scale_fill_manual(values = c("antiquewhite3", "cadetblue4")) +
        stat_pvalue_manual(stat.test_cover, label = "p.adj.signif", tip.length = 0.01, hide.ns = T) +

        labs(fill = "Survey Year",
             x = "Reef Flat Zone",
             y = "Mean Percent Cover (%)") +
        theme_pubr(legend = "right") +
        labs_pubr()
        
    
    

## 3.  Plot species richness ----
    
    summary_acrossyears %>%
        ggplot(aes(x = survey_year, y = sp_richness)) +
        geom_boxplot() +
        facet_grid(site~qualitative_transect_position) +
        theme_light()
    
    summary_acrossyears %>%
        group_by(survey_year, site, qualitative_transect_position) %>%
        summarize(mean_richness = mean(sp_richness),
                  std_error_richness = std.error(sp_richness)) %>%
        ggplot(aes(x = qualitative_transect_position, y = mean_richness,
                   fill = survey_year)) +
            geom_col(position = position_dodge(.9), color = "black") +
            geom_point(position = position_dodge(.9)) +
            geom_errorbar(aes(ymin = mean_richness - std_error_richness,
                              ymax = mean_richness + std_error_richness), 
                          width = 0.2, 
                          position = position_dodge(.9)) +
            scale_x_discrete(labels=c("inner_flat" = "Inner Flat", 
                                      "outer_flat" = "Outer Flat")) +
            scale_y_continuous(limits = c(0,8.25)) +
            scale_fill_manual(values = c("antiquewhite3", "cadetblue4"))+
            facet_wrap(~site) +
            labs(fill = "Survey Year",
                 x = "Reef Flat Position",
                 y = "Mean Species Richness") +
            theme_pubr(legend = "right") 
    
    
    stat.test_richness = summary_acrossyears %>%
        group_by(site, qualitative_transect_position) %>%
        t_test(sp_richness ~ survey_year) %>% 
        add_significance(p.col = "p", 
                         output.col = "p.adj.signif", 
                         cutpoints = c(0, 0.001, 0.01, 0.05, 1),
                         symbols = c("***", "**", "*", "ns")) %>%
        add_xy_position(x = "qualitative_transect_position", dodge = 0.9) %>%
        mutate(y.position = c(3.4, 8, 6.5, 6.5))
    
    ggbarplot(summary_acrossyears, 
              x = "qualitative_transect_position", y = "sp_richness", 
              fill = "survey_year",
              add = "mean_se",
              position = position_dodge(0.8),
              facet.by = "site") +
        scale_x_discrete(labels=c("inner_flat" = "Inner", 
                                  "outer_flat" = "Outer"), 
                         limits = c("inner_flat", "outer_flat")) +
        scale_fill_manual(values = c("antiquewhite3", "cadetblue4")) +
        stat_pvalue_manual(stat.test_richness, label = "p.adj.signif", tip.length = 0.01, hide.ns = T) +
        labs(fill = "Survey Year",
             x = "Reef Flat Zone",
             y = "Mean Species Richness") +
        theme_pubr(legend = "right") +
        labs_pubr()
    
    
## 4. Plot species accumulation curves ----
    
    # specaccum_acrossyears %>%
    #     ggplot(aes(x = transect, y = richness,
    #                color = as.character(year), shape = position)) +
    #         geom_point() +
    #         geom_line() +
    #         scale_color_manual(values = c("antiquewhite3", "cadetblue4")) +
    #         scale_shape_discrete(labels = c("Inner Reef Flat", "Outer Reef Flat")) +
    #         facet_wrap(~site) +
    #         scale_x_continuous(breaks = seq(0,10,2)) +
    #         labs(x = "Transect Number", y = "Species Richness", color = "Survey Year",
    #              shape = "Location") +
    #         theme_pubr(legend = "right")
    
    
## 5. Plot communities ----

    # * 5.1 Asan: Inner '99 vs Inner '22 ----
            plotting_asan_inner_99_22_NMDS %>%
                ggplot(aes(x = NMDS1, y = NMDS2, color = year)) +
                geom_point(size = 3, alpha = 0.4) +
                stat_ellipse(geom = "polygon", aes(color = year, 
                                                   fill = year),
                             alpha = 0.2) +        
                geom_point(size = 3, alpha = 0.6) +
                scale_fill_manual(values = c("antiquewhite3", "cadetblue4")) +
                scale_color_manual(values = c("antiquewhite3", "cadetblue4")) +
                labs(fill = "Survey Year", color = "Survey Year") +
                theme_pubr(legend = "right")
        
            ggplot() +
                geom_point(data = plotting_asan_inner_99_22_NMDS,
                           aes(x = NMDS1, y = NMDS2, 
                               color = year, 
                               shape = year),
                           size = 3, 
                           alpha = 0.8) +
                stat_ellipse(data = plotting_asan_inner_99_22_NMDS, 
                             aes(x = NMDS1, y = NMDS2, 
                                 color = year),
                             linetype = 2, size = 1) +
                geom_segment(data = significant_asan_inner_99_22_species_scores,
                             aes(x = 0, xend=NMDS1, y=0, yend=NMDS2),
                             arrow = arrow(length = unit(0.25, "cm")),
                             colour = "grey10", 
                             lwd = 0.3) +                                               # add vector arrows of significant env variables
                ggrepel::geom_text_repel(data = significant_asan_inner_99_22_species_scores, 
                                         aes(x=NMDS1, y=NMDS2, 
                                             label = abrev),
                                         cex = 3, 
                                         direction = "both", 
                                         segment.size = 0.25) +                          # add labels for species
                theme_light()
            
    find_hull = function(plotting_asan_inner_99_22_NMDS) plotting_asan_inner_99_22_NMDS[chull(plotting_asan_inner_99_22_NMDS$NMDS1, plotting_asan_inner_99_22_NMDS$NMDS2), ]
    hulls = ddply(plotting_asan_inner_99_22_NMDS, "year", find_hull)
    
    ggplot() +
        geom_polygon(data = hulls, aes(x = NMDS1, y = NMDS2, 
                                       fill = year, color = year),
                     alpha = 0.2) +
        geom_point(data = plotting_asan_inner_99_22_NMDS, 
                   aes(x = NMDS1, y = NMDS2, color = year)) +
        scale_fill_manual(values = c("antiquewhite3", "cadetblue4")) +
        scale_color_manual(values = c("antiquewhite3", "cadetblue4")) +
        # geom_label(aes(label = c("Agat", "Asan"), x = c(1.8, -0.5), y = c(0.85, 0.65)),
        #            color = "black", fill = c("#440154", "#fde725"), size = 3, alpha = 0.3) +
        geom_text(aes(label = "PERMANOVA; p = 0.0638", x = 0.7, y = -0.75), size = 3) +
        theme_bw() +
        labs_pubr() +
        rremove("grid") +
        rremove("legend")
    
    # * 5.2 Asan: Outer '99 vs Outer '22 ----
    plotting_asan_outer_99_22_NMDS %>%
        ggplot(aes(x = NMDS1, y = NMDS2, color = year)) +
        geom_point(size = 3, alpha = 0.4) +
        stat_ellipse(geom = "polygon", aes(color = year, 
                                           fill = year),
                     alpha = 0.2) +        
        geom_point(size = 3, alpha = 0.6) +
        scale_fill_manual(values = c("antiquewhite3", "cadetblue4")) +
        scale_color_manual(values = c("antiquewhite3", "cadetblue4")) +
        labs(fill = "Survey Year", color = "Survey Year") +
        theme_pubr(legend = "right")
    
    ggplot() +
        geom_point(data = plotting_asan_outer_99_22_NMDS,
                   aes(x = NMDS1, y = NMDS2, 
                       color = year, 
                       shape = year),
                   size = 3, 
                   alpha = 0.8) +
        stat_ellipse(data = plotting_asan_outer_99_22_NMDS, 
                     aes(x = NMDS1, y = NMDS2, 
                         color = year),
                     linetype = 2, size = 1) +
        geom_segment(data = significant_asan_outer_99_22_species_scores,
                     aes(x = 0, xend=NMDS1, y=0, yend=NMDS2),
                     arrow = arrow(length = unit(0.25, "cm")),
                     colour = "grey10", 
                     lwd = 0.3) +                                               # add vector arrows of significant env variables
        ggrepel::geom_text_repel(data = significant_asan_outer_99_22_species_scores, 
                                 aes(x=NMDS1, y=NMDS2, 
                                     label = abrev),
                                 cex = 3, 
                                 direction = "both", 
                                 segment.size = 0.25) +                          # add labels for species
        theme_light()
    
    
    find_hull = function(plotting_asan_outer_99_22_NMDS) plotting_asan_outer_99_22_NMDS[chull(plotting_asan_outer_99_22_NMDS$NMDS1, plotting_asan_outer_99_22_NMDS$NMDS2), ]
    hulls = ddply(plotting_asan_outer_99_22_NMDS, "year", find_hull)
    
    ggplot() +
        geom_polygon(data = hulls, aes(x = NMDS1, y = NMDS2, 
                                       fill = year, color = year),
                     alpha = 0.2) +
        geom_point(data = plotting_asan_outer_99_22_NMDS, 
                   aes(x = NMDS1, y = NMDS2, color = year)) +
        scale_fill_manual(values = c("antiquewhite3", "cadetblue4")) +
        scale_color_manual(values = c("antiquewhite3", "cadetblue4")) +
        # geom_label(aes(label = c("Agat", "Asan"), x = c(1.8, -0.5), y = c(0.85, 0.65)),
        #            color = "black", fill = c("#440154", "#fde725"), size = 3, alpha = 0.3) +
        geom_text(aes(label = "PERMANOVA; p = 0.342", x = 0.95, y = -0.95), size = 3) +
        theme_bw() +
        labs_pubr() +
        rremove("grid") +
        rremove("legend")
    
    # * 5.3 Agat: Inner '99 vs Inner '22 ----
    plotting_agat_inner_99_22_NMDS %>%
        ggplot(aes(x = NMDS1, y = NMDS2, color = year)) +
        geom_point(size = 3, alpha = 0.4) +
        stat_ellipse(geom = "polygon", aes(color = year, 
                                           fill = year),
                     alpha = 0.2) +        
        geom_point(size = 3, alpha = 0.6) +
        scale_fill_manual(values = c("antiquewhite3", "cadetblue4")) +
        scale_color_manual(values = c("antiquewhite3", "cadetblue4")) +
        labs(fill = "Survey Year", color = "Survey Year") +
        theme_pubr(legend = "right")
    
    ggplot() +
        geom_point(data = plotting_agat_inner_99_22_NMDS,
                   aes(x = NMDS1, y = NMDS2, 
                       color = year, 
                       shape = year),
                   size = 3, 
                   alpha = 0.8) +
        stat_ellipse(data = plotting_agat_inner_99_22_NMDS, 
                     aes(x = NMDS1, y = NMDS2, 
                         color = year),
                     linetype = 2, size = 1) +
        geom_segment(data = significant_agat_inner_99_22_species_scores,
                     aes(x = 0, xend=NMDS1, y=0, yend=NMDS2),
                     arrow = arrow(length = unit(0.25, "cm")),
                     colour = "grey10", 
                     lwd = 0.3) +                                               # add vector arrows of significant env variables
        ggrepel::geom_text_repel(data = significant_agat_inner_99_22_species_scores, 
                                 aes(x=NMDS1, y=NMDS2, 
                                     label = abrev),
                                 cex = 3, 
                                 direction = "both", 
                                 segment.size = 0.25) +                          # add labels for species
        theme_light()
    
    find_hull = function(plotting_agat_inner_99_22_NMDS) plotting_agat_inner_99_22_NMDS[chull(plotting_agat_inner_99_22_NMDS$NMDS1, plotting_agat_inner_99_22_NMDS$NMDS2), ]
    hulls = ddply(plotting_agat_inner_99_22_NMDS, "year", find_hull)
    
    ggplot() +
        geom_polygon(data = hulls, aes(x = NMDS1, y = NMDS2, 
                                       fill = year, color = year),
                     alpha = 0.2) +
        geom_point(data = plotting_agat_inner_99_22_NMDS, 
                   aes(x = NMDS1, y = NMDS2, color = year)) +
        scale_fill_manual(values = c("antiquewhite3", "cadetblue4")) +
        scale_color_manual(values = c("antiquewhite3", "cadetblue4")) +
        # geom_label(aes(label = c("Agat", "Asan"), x = c(1.8, -0.5), y = c(0.85, 0.65)),
        #            color = "black", fill = c("#440154", "#fde725"), size = 3, alpha = 0.3) +
        geom_text(aes(label = "PERMANOVA; p = 0.650", x = 0.3, y = 0.8), size = 3) +
        theme_bw() +
        labs_pubr() +
        rremove("grid") +
        rremove("legend")
    
    # * 5.4 Agat: Outer '99 vs Outer '22 ----
    plotting_agat_outer_99_22_NMDS %>%
        ggplot(aes(x = NMDS1, y = NMDS2, color = year)) +
        geom_point(size = 3, alpha = 0.4) +
        stat_ellipse(geom = "polygon", aes(color = year, 
                                           fill = year),
                     alpha = 0.2) +        
        geom_point(size = 3, alpha = 0.6) +
        scale_fill_manual(values = c("antiquewhite3", "cadetblue4")) +
        scale_color_manual(values = c("antiquewhite3", "cadetblue4")) +
        labs(fill = "Survey Year", color = "Survey Year") +
        theme_pubr(legend = "right")
    
    ggplot() +
        geom_point(data = plotting_agat_outer_99_22_NMDS,
                   aes(x = NMDS1, y = NMDS2, 
                       color = year, 
                       shape = year),
                   size = 3, 
                   alpha = 0.8) +
        stat_ellipse(data = plotting_agat_outer_99_22_NMDS, 
                     aes(x = NMDS1, y = NMDS2, 
                         color = year),
                     linetype = 2, size = 1) +
        geom_segment(data = significant_agat_outer_99_22_species_scores,
                     aes(x = 0, xend=NMDS1, y=0, yend=NMDS2),
                     arrow = arrow(length = unit(0.25, "cm")),
                     colour = "grey10", 
                     lwd = 0.3) +                                               # add vector arrows of significant env variables
        ggrepel::geom_text_repel(data = significant_agat_outer_99_22_species_scores, 
                                 aes(x=NMDS1, y=NMDS2, 
                                     label = abrev),
                                 cex = 3, 
                                 direction = "both", 
                                 segment.size = 0.25) +                          # add labels for species
        theme_light()
    
    find_hull = function(plotting_agat_outer_99_22_NMDS) plotting_agat_outer_99_22_NMDS[chull(plotting_agat_outer_99_22_NMDS$NMDS1, plotting_agat_outer_99_22_NMDS$NMDS2), ]
    hulls = ddply(plotting_agat_outer_99_22_NMDS, "year", find_hull)
    
    ggplot() +
        geom_polygon(data = hulls, aes(x = NMDS1, y = NMDS2, 
                                       fill = year, color = year),
                     alpha = 0.2) +
        geom_point(data = plotting_agat_outer_99_22_NMDS, 
                   aes(x = NMDS1, y = NMDS2, color = year)) +
        scale_fill_manual(values = c("antiquewhite3", "cadetblue4")) +
        scale_color_manual(values = c("antiquewhite3", "cadetblue4")) +
        # geom_label(aes(label = c("Agat", "Asan"), x = c(1.8, -0.5), y = c(0.85, 0.65)),
        #            color = "black", fill = c("#440154", "#fde725"), size = 3, alpha = 0.3) +
        geom_text(aes(label = "PERMANOVA; p = 0.103", x = 0.75, y = 0.85), size = 3) +
        theme_bw() +
        labs_pubr() +
        rremove("grid") +
        # labs(fill = "Survey Year", color = "Survey Year")
        rremove("legend")
    
    
## 6. Plot community composition by species ----
    
    comm_for_plotting %>%
        ggplot(aes(x = qualitative_transect_position, y = Value, fill = Species)) +
        geom_bar(position = "fill", stat = "identity") +
        facet_wrap(year~Site, nrow = 2) + 
        scale_x_discrete(labels=c("inner_flat" = "Inner Flat", 
                                  "outer_flat" = "Outer Flat")) +
        labs(x = "Reef Flat Position", y = "Proportion of Coral Community", 
             fill = "Species Code") +
        theme_pubr(legend = "right")
        

## 7. Plot diversity ----
    
    
    combined_diversity = rbind(shannon_ames, shannon_current)
    
    combined_diversity %<>%
        mutate(year = as.character(year))
    
    stat.test_diversity = combined_diversity %>%
        group_by(site, position) %>%
        t_test(shannon_diversity ~ year) %>% 
        add_significance(p.col = "p", 
                         output.col = "p.adj.signif", 
                         cutpoints = c(0, 0.001, 0.01, 0.05, 1),
                         symbols = c("***", "**", "*", "ns")) %>%
        add_xy_position(x = "position", dodge = 0.9) %>%
        mutate(y.position = c(1, 1.55, 1, 1.3))
    
    ggbarplot(combined_diversity, 
              x = "position", y = "shannon_diversity", 
              fill = "year",
              add = "mean_se",
              position = position_dodge(0.8),
              facet.by = "site") +
        scale_x_discrete(labels=c("inner" = "Inner", 
                                  "outer" = "Outer"), 
                         limits = c("inner", "outer")) +
        scale_fill_manual(values = c("antiquewhite3", "cadetblue4")) +
        stat_pvalue_manual(stat.test_diversity, label = "p.adj.signif", tip.length = 0.01, hide.ns = T) +
        labs(fill = "Survey Year",
             x = "Reef Flat Zone",
             y = "Mean Diversity (H)") +
        theme_pubr(legend = "right") +
        labs_pubr()
    