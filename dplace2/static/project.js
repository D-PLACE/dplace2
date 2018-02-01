DPLACE2 = {};

DPLACE2.style = function (feature) {
    return {
        'color': '#000',
        'weight': 2,
        'opacity': 0.2,
        'fillOpacity': 0.1,
        'fillColor': '#fef'
    }
};

CLLD.LayerOptions.regions = {
    style: DPLACE2.style,
    onEachFeature: function (feature, layer) {
        layer.bindTooltip(feature.properties.REGION_NAM);
    }
};

CLLD.MapIcons.div = function (feature, size, url) {
    return L.divIcon({
        //html: '<div class="dplace-map-icon" style="background: ' + feature.properties.color + ';">☺</div>',
        html: '<div class="dplace-map-icon" style="background: ' + feature.properties.color + ';">&nbsp;</div>',
        className: 'clld-map-icon'
    });
};

DPLACE2.nodeStyler = function (container, node) {
    var text;
    if (d3.layout.phylotree.is_leafnode(node)) {
        //container.attr("xlink:href", "http://glottolog.org/");
        text = container.select("text");
        if (!text.text().endsWith('abcd')) {
            text.text('   ' + text.text() + ' ').attr("fill", "red");
            container.append("circle")
                .attr("height", 12)
                .attr("width", 12)
                .style("fill", "lightgreen")
                .attr("r", 5)
                .attr("stroke", "#000")
                .attr("stroke-width", "0.5")
                .on("mouseover", function () {
                    d3.select("body").append("div")
                        .attr("class", "tree-tooltip")
                        .html("<b>hello</b>")
                        .style("z-index", 1000)
                        .style("max-width", "250px")
                        .style("left", (d3.event.pageX + 10) + "px")
                        .style("top", (d3.event.pageY + 5) + "px");
                })
                .on("mouseout", function () {
                    d3.select(".tree-tooltip").remove();
                });
        }
    }
};