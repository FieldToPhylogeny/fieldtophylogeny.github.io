# =============================================================================
# Field to Phylogeny 2026 · Module 5
# Plot a bootstrapped RAxML tree for a paper, then link each sample to its
# collection locality on a map of Madagascar.
#
# Inputs (put them in the same folder as this script):
#   1. your tree from Module 4 (Newick; bootstrap values as node labels)
#   2. a CSV with one row per sample: sample, lat, long   (decimal degrees)
#      - "sample" must match the tip labels in the tree exactly
#      - latitudes in Madagascar are NEGATIVE (south of the equator)
# =============================================================================

# ---- 0. Install packages (once, before the workshop: they are large) --------
# install.packages(c("ape", "phytools", "maps", "ggplot2"))
# install.packages("BiocManager")
# BiocManager::install("ggtree")

library(ape)       # read, root and edit trees
library(ggtree)    # publication-quality tree figures (built on ggplot2)
library(ggplot2)
library(phytools)  # phylo.to.map(): tree linked to a map
library(maps)      # world map outlines, including Madagascar

# Tell R where your files are (or use Session > Set Working Directory)
# setwd("C:/Users/yourname/Desktop/F2P_Module5")

# ---- 1. Read the tree ------------------------------------------------------
tree <- read.tree("GroupA_COI.raxml.support")   # change to your file name
tree                                             # how many tips? rooted?
tree$tip.label                                   # check the names

# ---- 2. Root with the outgroup ---------------------------------------------
# Use the exact tip label(s) of your outgroup. edgelabel = TRUE keeps every
# bootstrap value attached to the right branch when the root moves.
outgroup <- c("Madagascarophis_sp2_RAX12582")
tree <- root(tree, outgroup = outgroup, resolve.root = TRUE, edgelabel = TRUE)
is.rooted(tree)

# Ladderize: rotate nodes so the tree reads neatly (relationships do not change)
tree <- ladderize(tree, right = FALSE)

# Quick look with base R
plot(tree, cex = 0.6)
nodelabels(tree$node.label, frame = "none", cex = 0.5, adj = c(1.2, -0.4))
add.scale.bar()

# ---- 3. A tree for a paper with ggtree -------------------------------------
# Genus = the part of the tip label before the first "_"
tipdata <- data.frame(label = tree$tip.label,
                      genus = sub("_.*", "", tree$tip.label))

p <- ggtree(tree, linewidth = 0.4) %<+% tipdata

# bootstrap values are stored as text; turn them into numbers
p$data$support <- suppressWarnings(as.numeric(p$data$label))

p <- p +
  geom_tiplab(aes(colour = genus), fontface = "italic", size = 2.6, offset = 0.002) +
  geom_text2(aes(subset = !isTip & !is.na(support) & support >= 70, label = support),
             hjust = 1.3, vjust = -0.5, size = 2.2) +                     # show only BS >= 70
  geom_point2(aes(subset = !isTip & !is.na(support) & support >= 95),
              size = 1.4, colour = "black") +                              # dot = strong support
  geom_treescale(x = 0, y = -1.5, width = 0.05, fontsize = 2.5, linesize = 0.4) +
  scale_colour_brewer(palette = "Dark2", guide = "none") +
  hexpand(0.35) +                                                          # room for long names
  theme_tree()

p

# Highlight a clade (find the node number first: MRCA of two tips in it)
# node <- MRCA(tree, c("Compsophis_boulengeri_RAN44850", "Compsophis_zeny_RAN44452"))
# p <- p + geom_cladelab(node = node, label = "Compsophis", offset = 0.06,
#                        barsize = 1, fontsize = 3, angle = 0)

ggsave("Figure_tree.pdf", p, width = 7, height = 10)   # PDF stays sharp in a paper
ggsave("Figure_tree.png", p, width = 7, height = 10, dpi = 300)

# ---- 4. Read the coordinates -----------------------------------------------
coords <- read.csv("sample_coordinates.csv")   # columns: sample, lat, long
head(coords)

# Which tree tips have coordinates? (names must match exactly)
setdiff(tree$tip.label, coords$sample)   # tips with no coordinates
setdiff(coords$sample, tree$tip.label)   # coordinates with no tip

# Keep only the samples that have both
keep <- intersect(tree$tip.label, coords$sample)
tr <- keep.tip(tree, keep)
X <- as.matrix(coords[match(keep, coords$sample), c("lat", "long")])
rownames(X) <- keep

# ---- 5. Quick map of the localities ----------------------------------------
mdg <- map_data("world", region = "Madagascar")
coords$genus <- sub("_.*", "", coords$sample)

m <- ggplot() +
  geom_polygon(data = mdg, aes(long, lat, group = group), fill = "grey92", colour = "grey40", linewidth = 0.3) +
  geom_point(data = coords, aes(long, lat, colour = genus), size = 2) +
  coord_quickmap(xlim = c(43, 51), ylim = c(-26, -11.5)) +
  scale_colour_brewer(palette = "Dark2") +
  labs(x = "Longitude", y = "Latitude", colour = NULL) +
  theme_minimal()
m
ggsave("Figure_map.pdf", m, width = 5, height = 7)

# ---- 6. Tree linked to the map with dashed lines ---------------------------
# Colour each sample by genus (same colours on the lines and the points)
genus <- sub("_.*", "", rownames(X))
pal <- setNames(RColorBrewer::brewer.pal(max(3, length(unique(genus))), "Dark2")[seq_along(unique(genus))],
                unique(genus))
cols <- setNames(pal[genus], rownames(X))

obj <- phylo.to.map(tr, X, database = "world", regions = "Madagascar",
                    xlim = c(43, 51), ylim = c(-26, -11.5),
                    rotate = TRUE,   # turn nodes to reduce crossing lines
                    plot = FALSE)

pdf("Figure_tree_map.pdf", width = 10, height = 8)
plot(obj, direction = "rightwards",   # tree on the left, map on the right
     ftype = "i", fsize = 0.55,       # italic tip labels
     lty = "dashed", lwd = 0.8,       # dashed lines from tips to localities
     colors = cols, pts = TRUE,       # coloured lines and points
     cex.points = c(0, 1.1))
dev.off()

# Same plot in the RStudio window
plot(obj, direction = "rightwards", ftype = "i", fsize = 0.55,
     lty = "dashed", lwd = 0.8, colors = cols, pts = TRUE, cex.points = c(0, 1.1))
