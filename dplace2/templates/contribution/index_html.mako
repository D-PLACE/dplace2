<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "contributions" %>
<%block name="title">${_('Contributions')}</%block>

<h2>${_('Contributions')}</h2>
<div>
    ${ctx.render()}
</div>


<%util:section title="Sources" level="3" id="sources">
    <p>
        D-PLACE contains cultural, linguistic, environmental and geographic information
        for over 1400 human cultural groups. This data is aggregated from a number of
        <a href="${req.route_url('contributions')}">datasets</a>.
    </p>

    <h4 id="cultural_data">Cultural data</h4>
    <p>
        D-PLACE includes cultural data from four major cross-cultural datasets: the
        Ethnographic Atlas (Murdock 1962-1971; Barry 1980; Gray 1999; Korotayev et al. 2004; Bondarenko et al. 2005),
        the Binford Hunter-Gatherer dataset (Binford 2001; Binford and Johnson 2006) (as described in
        ${h.external_link('https://doi.org/10.1371/journal.pone.0158391', label='Kirby et al. (2016)')}),
        the Standard Cross Cultural Sample (White and Murdock 1969) and the
        Western North American Indians dataset (Jorgensen 1980, 1999a and 1999b).
        All four datasets use codes to characterize the cultural practices of a ‘society’, or group of people with a
        shared language and cultural identity at a given location and point in time.
    </p>
    <p>
        All cultural descriptions are tagged with the date to which they refer, a geographic location
        (using a reported latitude and longitude) and language. This allows users to simultaneously consider
        how cultural practices relate to linguistic ancestry, practices of neighbouring groups, and the environment.
    </p>
    <p>
        The authors of the cultural datasets relied on a huge number of
        <a href="${req.route_url('sources')}">primary data sources</a> to code cultural practices of societies in their
        samples.
        Most of these sources are original ethnographies published as academic journal articles or books. While Murdock,
        Binford
        and their successors carefully documented their sources, the references were for the most part excluded from
        early
        attempts to digitize the <a href="${req.route_url('source', id='EA')}">EA</a> and
        <a href="${req.route_url('source', id='Binford')}">Binford</a> datasets. Also lost from early digital datasets
        were the authors’ comments
        regarding particular coding decisions, despite the insights and caveats these comments provide.
    </p>
    <p>
        In D-PLACE, each cultural data point is tagged with both its primary sources and coding comments, with
        references for
        the primary sources and comments included in results tables and data downloads. We encourage users to draw on
        this
        information when considering intracultural variation and uncertainty in cultural codes, and to return to the
        primary
        sources for a better understanding of particular coding decisions.
    </p>

    <p>
        In order to facilitate access to supplementary cultural data for D-PLACE societies, we provide information on
        whether each society appears in other major cross-cultural databases. In addition ot the four datasets described
        above, we have included links to the Human Relations Area Files (HRAF) (Murdock 1983), a repository of annotated
        primary literature that can be searched by topic e.g., marriage system (see this page on eHRAF and D-PLACE
        collaboration) and the CHIRILA database of Australian languages (Bowern 2016).
    </p>
    <p>
        These links to other cross-cultural datasets appear at the top of individual “Society” results pages. Kirby et
        al. (2016) includes a discussion regarding the combination of data from different cross-cultural datasets,
        including the importance of considering agreement among focal year and focal location. More thorough discussions
        are included in Ember et al. (1992) and Ember (2007).
    </p>

    <h4 id="linguistic_data">Linguistic data</h4>
    <h5>Language family</h5>
    <p>
        The language spoken by a society is an important indicator for historical relatedness, cultural identity and
        contact. D-PLACE specifies the broad language family affiliation for all societies, using the classification
        systems of Glottolog (Hammarström et al. 2015). Users can treat language family as a variable of interest
        itself, or can use it as a coarse-level control for relatedness among societies (e.g., Botero et al. 2014).
    </p>
    <h5>Historical relationships among languages: Glottolog trees</h5>
    <p>
        At a closer resolution, all societies in D-PLACE have been linked to a language and, in cases where the language
        was shared with another D-PLACE society, to a Glottolog dialect. Languages are identified by both a Glottolog ID
        and an ISO 639-3 code, and dialects by a Glottolog ID (Hammarström et al. 2015; SIL International 2015). For
        languages for which an ISO 639-3 code has not been assigned, we use a D-PLACE serial number as a place-holder
        (x01, x02...; all within the ISO-639-3 private use range). Languages and dialects are used by D-PLACE to link
        each society to Glottolog’s language classification trees. These trees are topological only, representing
        genealogical hypotheses of how languages are nested, based on comparative historical linguistic work. The
        classifications are purely taxonomies and branch lengths do not represent time or amount of change.
    </p>
    <h5>Distance among languages: phylogenies</h5>
    <p>
        At the finest scale, many of the societies in each cross-cultural dataset belong to a language family for which
        a well-resolved and computationally-derived phylogenetic tree is available (for example: Gray et al 2009,
        Kitchen et al. 2009, Dunn et al. 2011, Lee and Hasegawa 2011, Bowern and Atkinson 2012, Bouckaert et al 2012,
        Chacon and List 2015, Grollemund et al. 2015, Sicoli & Holton 2015, Lee 2015). In focusing analyses on these
        societies, researchers gain the ability to conduct sophisticated hypothesis testing about evolutionary change
        using phylogenetic comparative methods, as well as robust control for historical relatedness. For example, the
        relative time since language divergence can be used as a measure of relative distance among societies. Of
        course, while language provides a highly effective proxy for shared history, language family affiliation may not
        always reflect deep cultural or linguistic ancestry. Numerous instances of language shift, contact, and
        borrowing occur when societies interact. For example, many Central African Pygmy groups have adopted the
        languages of their Bantu trading partners (Bahuchet 2012). In such cases, linguistic relationships still capture
        meaningful aspects of cultural interaction, but users will need to make their own context-specific judgments.
    </p>
    <p>
        For details on how societies were matched to languages, please see Kirby et al. (2016).
    </p>

    <h4>Environmental data</h4>
    <p>
        We sampled environmental variables at the localities reported for each society in each dataset (EA, Binford,
        WNAI, SCCS), with some adjustments to geographic coordinates as outlined in Kirby et al. (2016). Both the
        original and revised latitude and longitude for all societies are included in CSV downloads of search results
        from this site.
    </p>
    <h4>Climate</h4>
    <p>
        For each society, we computed the mean, variance, and predictability of the entire annual cycles of
        precipitation and temperature based on monthly global maps (0.5 by 0.5 degree cells) obtained from the Baseline
        Historical (1900-1949), CCSM ecoClimate model (Lima-Ribeiro,M. et al. 2015). Predictability was measured via
        Colwell’s (1974) Constancy, Contingency and Predictability indexes. These indexes capture the extent to which
        yearly cycles vary among years in terms of onset, intensity and duration, ranging from 0 (completely
        unpredictable) to 1 (fully predictable). We include constancy (the extent to which a variable can be predicted
        because it tends to stay fairly constant) and contingency (the extent to which predictions are possible because
        environmental cycles are highly repeatable) in order to allow interested users to explore the potentially
        different impacts of these two types of predictability. Because the cultural data for the vast majority of
        societies in D-PLACE was collected between 1901 and 1950, we sampled climatic variables at each locality for
        this particular time period.
    </p>
    <h4>Productivity and biodiversity</h4>
    <p>
        Ecoregion and biome locations of each society were obtained from Olson et al. (2001). Monthly net primary
        production data were obtained from the MODIS dataset (Running et al. 1999, Data range: 2000-2016). From these
        data we computed the annual mean, variance predictability, constancy and contingency of net primary productivity
        at each sampled locality. Estimates of the number of species at each site were obtained for birds, mammals, and
        amphibians from Jenkins et al. (2013) and for vascular plants from Kreft and Jetz (2007).
    </p>
    <h4>Physical environment</h4>
    <p>
        We also include estimates of distance from a coast, elevation, and slope for all societies, with topographical
        data provided by the Global Multi-resolution Terrain Elevation Data of the U.S. Geological Survey.
    </p>


    <h4>References</h4>
    <ul>
        <li>Anderson, J. L., Crawford, C. B., Nadeau, J., &amp; Lindberg, T. (1992). Was the Duchess of Windsor right? A
            cross-cultural review of the socioecology of ideals of female body shape. Ethology and Sociobiology, 13(3),
            197-227.
        </li>
        <li>Bahuchet, S. (2012). Changing language, remaining pygmy. Human Biology, 84(1), 11-43.</li>
        <li>Barry, H., &amp; Paxson, L. M. (1971). Infancy and early childhood: Cross-cultural codes 2. Ethnology,
            10(4), 466-508.
        </li>
        <li>Barry, H. (1980). Ethnographic Atlas XXVIII. Ethnology 19(2): 245-263.</li>
        <li>Barry, H., &amp; Schlegel, A. (1982). Cross-cultural codes on contributions by women to subsistence.
            Ethnology, 21(2), 165-188.
        </li>
        <li>Barry, H., &amp; Schlegel, A. (1984). Measurements of adolescent sexual behavior in the standard sample of
            societies. Ethnology, 23(4), 315-329.
        </li>
        <li>Barry, H., Josephson, L., Lauer, E., &amp; Marshall, C. (1976). Traits inculcated in childhood:
            Cross-cultural codes 5. Ethnology, 15(1), 83-106.
        </li>
        <li>Barry, H., Josephson, L., Lauer, E., &amp; Marshall, C. (1977). Agents and techniques for child training:
            Cross-cultural codes 6. Ethnology, 16(2), 191-230.
        </li>
        <li>Betzig, L. (1989). Causes of conjugal dissolution: A cross-cultural study. Current Anthropology, 30(5),
            654-676.
        </li>
        <li>Betzig, L. L. (1986). Despotism and differential reproduction: A Darwinian view of history. Aldine
            Publishing Co.
        </li>
        <li>Binford, L. R. (2001). Constructing frames of reference: an analytical method for archaeological theory
            building using ethnographic and environmental data sets. Univ of California Press.
        </li>
        <li>Binford, L. R., and Johnson, A. L. (2006). Documentation for Program for Calculating Environmental and
            Hunter-Gatherer Frames of Reference (ENVCALC2). Java version, August 2006.
        </li>
        <li>Bondarenko, D., Kazankov, A., Khaltourina, D., and Korotayev, A. (2005). Ethnographic atlas XXXI: Peoples of
            easternmost Europe. Ethnology, 261–289.
        </li>
        <li>Botero, C.A., Gardner, B, Kirby, K.R., Bulbulia, J., Gavin, M.C. and Gray, R.D. (2014) The ecology of
            religious beliefs. Proceedings of the National Academy of Sciences. 111 (47), 16784-16789.
        </li>
        <li>Bouckaert, R., Lemey, P., Dunn, M., Greenhill, S. J., Alekseyenko, A. V., Drummond, A. J., Gray, R. D.,
            Suchard, M. A., and Atkinson, Q. D. (2012). Mapping the Origins and Expansion of the Indo-European Language
            Family. Science 337, 957. DOI: 10.1126/science.1219669.
        </li>
        <li>Bowern, C. (2016). Chirila: Contemporary and Historical Resources for the Indigenous Languages of Australia.
            Language Documentation and Conservation. February, 2016. Vol 10: 1-44. <a
                    href="http://nflrc.hawaii.edu/ldc/?p=1002" target="_blank">http://nflrc.hawaii.edu/ldc/?p=1002</a>.
        </li>
        <li>Bowern, C., and Atkinson, Q. (2012). Computational phylogenetics and the internal structure of Pama-Nyungan.
            Language, 88(4), 817-845.
        </li>
        <li>Bradley, C. (1994). The Household Division of Work: SCCS Codes. World Cultures, 8(2), 6-40.</li>
        <li>Bradley, C., Moore, C. C., Burton, M. L., &amp; White, D. R. (1990). A Cross?Cultural Historical Analysis of
            Subsistence Change. American Anthropologist, 92(2), 447-457.
        </li>
        <li>Broude, G. J., &amp; Greene, S. J. (1976). Cross-cultural codes on twenty sexual attitudes and practices.
            Ethnology, 15(4), 409-429.
        </li>
        <li>Broude, G. J., &amp; Greene, S. J. (1983). Cross-cultural codes on husband-wife relationships. Ethnology,
            22(3), 263-280.
        </li>
        <li>Burton, M. L. (1999). Language and region codes for the standard cross-cultural sample. Cross-Cultural
            Research, 33(1), 63-83.
        </li>
        <li>Cashdan, E. (2001). Ethnic diversity and its environmental determinants: Effects of climate, pathogens, and
            habitat diversity. American Anthropologist, 103(4), 968-991.
        </li>
        <li>Chacon T. C., and List, J. M. (2015) Improved computational models of sound change shed light on the history
            of the Tukanoan languages. Journal of Language Relationship • <span style="font-family:'Arial'">Вопросы языкового родства.</span>
            13:177-203.
        </li>
        <li>Colwell R. K. (1974) Predictability, constancy, and contingency of periodic phenomena. Ecology. 1:1148-53.
        </li>
        <li>Dirks, R. (1993). Starvation and famine: cross-cultural codes and some hypothesis tests. Cross-Cultural
            Research, 27(1-2), 28-69.
        </li>
        <li>Divale, W. (1999). Climatic instability, food storage, and the development of numerical counting: A
            cross-cultural study. Cross-cultural research, 33(4), 341-368.
        </li>
        <li>Divale, W. and Seda, A. (2000). Cross-cultural codes of modernization. World Cultures, 11(2), 152-170.</li>
        <li>Divale, W. T., Abrams, N., Barzola, J., Harris, E., &amp; Henry, F. M. (1998). Sleeping arrangements of
            children and adolescents: SCCS sample codes. World Cultures, 9(2), 3-12.
        </li>
        <li>Divale, W., &amp; Seda, A. (1999). Codes on Gossip for Societies in the Standard Sanple. World Cultures,
            10(1), 7-22.
        </li>
        <li>Divale, W., &amp; Seda, A. (1999). Codes on Gossip for Societies in the Standard Sanple. World Cultures,
            10(1), 7-22.
        </li>
        <li>Dunn M., Greenhill, S. J., Levinson, S. C., and Gray, R.D. (2011) Evolved structure of language shows
            lineage-specific trends in word-order universals. Nature. 5;473(7345):79-82.
        </li>
        <li>Ember, C. R., &amp; Ember, M. (1992). Warfare, aggression, and resource problems: Cross-cultural codes.
            Behavior Science Research, 26(1-4), 169-226.
        </li>
        <li>Ember, C. R., Page, H., Martin, M. M., and O’Leary, T. (1992). A computerized concordance of cross-cultural
            samples. New Haven: Human Relations Area Files.
        </li>
        <li>Ember, C. R. (2007). Using the HRAF collection of ethnography in conjunction with the Standard
            Cross-Cultural Sample and the Ethnographic Atlas. Cross-Cultural Research, 41(4), 396–427.
        </li>
        <li>Frayser, S. G. (1985). Varieties of sexual experience: An anthropological perspective on human sexuality.
            Human Relations Area Files.
        </li>
        <li>Gray, J. P. (1999). A corrected ethnographic atlas. World Cultures, 10(1), 24–85.</li>
        <li>Gray, R. D., Drummond, A. J., and Greenhill, S. J. (2009). Language phylogenies reveal expansion pulses and
            pauses in Pacific settlement. Science, 323(5913), 479–483.
        </li>
        <li>Grollemund, R., Branford, S., Bostoen, K., Meade, A., Venditti, C., and Pagel, M. (2015). Bantu expansion
            shows that habitat alters the route and pace of human dispersals. Proceedings of the National Academy of
            Sciences (PNAS) 112(43), 13296-13301.
        </li>
        <li>Hammarström, H., Forkel, R., Haspelmath, M., Bank, S. (2015). Glottolog 2.7. Jena: Max Planck Institute for
            the Science of Human History. Accessed 2015-2016. URL: <a href="http://glottolog.org" target="_blank">http://glottolog.org</a>.
        </li>
        <li>Jenkins, C. N., Pimm, S. L., and Joppa, L. N. (2013). Global patterns of terrestrial vertebrate diversity
            and conservation. Proceedings of the National Academy of Sciences, 110(28), E2602–E2610.
        </li>
        <li>Jorgensen, J. G. (1980). Western Indians: Comparative environments, languages, and cultures of 172 Western
            American Indian tribes. San Francisco: WH Freeman. [Original monograph, source of bibliography for Jorgensen
            societies that is included in D-PLACE]
        </li>
        <li>Jorgensen, J. G. (1999a). An empirical procedure for defining and sampling culture bearing units in
            continuous geographic areas. World Cultures, 10(2), 139-143. [Describes sample of 172 societies]
        </li>
        <li>Jorgensen, J. G. (1999b). Codebook for Western Indians Data. World Cultures, 10(2), 144-293. [Defines
            codes]
        </li>
        <li>Kirby, K. R., Gray, R. D., Greenhill, S. J., Jordan, F. M., Gomes-Ng, S. Bibiko, H. J., Blasi, D. E.,
            Botero, C. A., Bowern, C., Ember, C. R., Leehr, D., Low, B. S., McCarter, J., Divale, W. and Gavin, M.
            (Submitted). D-PLACE: A Global Database of Cultural, Linguistic and Environmental Diversity.
        </li>
        <li>Kitchen, A., Ehret, C., Assefa, S., and Mulligan, C. J. (2009). Bayesian phylogenetic analysis of Semitic
            languages identifies an Early Bronze Age origin of Semitic in the Near East. Proceedings of the Royal
            Society of London B: Biological Sciences, rspb-2009. doi:10.1098/rspb.2009.0408.
        </li>
        <li>Korotayev, A. (2004). World religions and social evolution of the old world Oikumene civilizations: A
            cross-cultural perspective. E. Mellen Press.
        </li>
        <li>Korotayev, A., Kazankov, A., Borinskaya, S., Khaltourina, D., and Bondarenko, D. (2004). Ethnographic atlas
            XXX: peoples of Siberia. Ethnology, 83–92.
        </li>
        <li>Kreft, H., and Jetz, W. (2007). Global patterns and determinants of vascular plant diversity. Proceedings of
            the National Academy of Sciences, 104(14), 5925–5930.
        </li>
        <li>Lang, H. (1998). CONAN: An electronic code-text data-base for cross-cultural studies. World Cultures, 9(2),
            13-56.
        </li>
        <li>Lee, S., and Hasegawa, T. (2011). Bayesian phylogenetic analysis supports an agricultural origin of Japonic
            languages. Proceedings of the Royal Society of London B: Biological Sciences, rspb20110518.
        </li>
        <li>Lee, S. (2015). A Sketch of Language History in the Korean Peninsula. PloS one, 10(5), e0128448.</li>
        <li>Lima-Ribeiro, M. et al. 2015. ecoClimate: a database of climate data from multiple models for past, present,
            and future for Macroecologists and Biogeographers. Biodiversity Informatics 10, 1-21.
        </li>
        <li>Low, B. S. (1994). Pathogen intensity cross-culturally. World Cultures, 8(1), 24-34.</li>
        <li>Ludvico, L. R. (1994). Scarification, pathogen load and biome: Cross-cultural codes. World Cultures 9(1).
        </li>
        <li>Murdock, G. P. (1957). World ethnographic sample. American anthropologist, 59(4), 664-687.</li>
        <li>Murdock, G. P. (1962-1971). Ethnographic Atlas, Installments I-XXVII. Ethnology, 1-10.</li>
        <li>Murdock, G. P. (1965). Ethnographic Atlas IVX. Ethnology, 4(2) 241-250.</li>
        <li>Murdock, G. P. (1967) Ethnographic Atlas. Pittsburgh: University of Pittsburgh Press.</li>
        <li>Murdock, G. P. and White, D. R. (1969). Standard Cross-Cultural Sample. Ethnology 8: 329-369.</li>
        <li>Murdock, G. P. (1970). Kin term patterns and their distribution. Ethnology, 9(2), 165-208.</li>
        <li>Murdock, G. P., &amp; Morrow, D. O. (1970). Subsistence economy and supportive practices: Cross-cultural
            codes 1. Ethnology, 9(3), 302-330.
        </li>
        <li>Murdock, G. P., &amp; Wilson, S. F. (1972). Settlement patterns and community organization: Cross-cultural
            codes 3. Ethnology, 11(3), 254-295.
        </li>
        <li>Murdock, G. P., &amp; Provost, C. (1973). Factors in the division of labor by sex: A cross-cultural
            analysis. Ethnology, 12(2), 203-225.
        </li>
        <li>Murdock, G. P., &amp; Provost, C. (1973). Measurement of cultural complexity. Ethnology, 12(4), 379-392.
        </li>
        <li>Murdock, G. P. (1980). Theories of illness: A world survey. University of Pittsburgh Pre.</li>
        <li>Murdock, G. P. (1983). Outline of world cultures. Sixth Edition. New Haven Ct: Human Relations Area Files.
        </li>
        <li>Murdock, G. P., and White, D. R. (1969). Standard cross-cultural sample. Ethnology, 329–369.</li>
        <li>Nammour, V. W. (1974). Drums And Guns: A Cross-cultural Study Of The Nature Of War. (Doctoral Dissertation,
            University of Oregon).
        </li>
        <li>Olson, D. M., Dinerstein, E., Wikramanayake, E. D., Burgess, N. D., Powell, G. V. N., Underwood, E. C.,
            D'amico, J. A., Itoua, I., Strand, H. E., Morrison, J. C., Loucks, C. J., Allnutt, T. F., Ricketts, T. H.,
            Kura, Y., Lamoreux, J. F., Wettengel, W. W., Hedao, P., and Kassem, K. R. (2001). Terrestrial Ecoregions of
            the World: A New Map of Life on Earth A new global map of terrestrial ecoregions provides an innovative tool
            for conserving biodiversity. BioScience, 51(11), 933–938.
        </li>
        <li>Paige, K., &amp; Paige, J. M. (1981). The politics of reproductive ritual. Univ of California Press.</li>
        <li>Patterson, O. (1982). Slavery and social death. Harvard University Press.</li>
        <li>Pryor, F. L. (1985). The invention of the plow. Comparative Studies in Society and history, 27(4),
            727-743.
        </li>
        <li>Pryor, F. L. (1986). The adoption of agriculture: Some theoretical and empirical evidence. American
            Anthropologist, 88(4), 879-894.
        </li>
        <li>Roberts, J. M. (1976). Belief in the evil eye in world perspective. In Maloney, C. (Ed.). The evil eye.
            Columbia University Press. p 223-278.
        </li>
        <li>Rohner, R. P., &amp; Rohner, E. C. (1981). Parental acceptance-rejection and parental control:
            Cross-cultural codes. Ethnology, 20(3), 245-260.
        </li>
        <li>Rohner, R. P., &amp; Rohner, E. C. (1982). Enculturative continuity and the importance of caretakers:
            Cross-cultural codes. Behavior Science Research, 17(1-2), 91-114.
        </li>
        <li>Rohner, R. P., Berg, D. S., &amp; Rohner, E. C. (1982). Data quality control in the standard cross-cultural
            sample: cross-cultural codes. Ethnology, 21(4), 359-369.
        </li>
        <li>Rosenblatt, P. C. (1990). Cross-cultural variation in the experience, expression, and understanding of
            grief. In Irish, D. P., Lundquist, K. F., Jenkins Nelsen, V. (Eds.). Ethnic variations in dying, death and
            grief: Diversity in universality. Taylor &amp; Francis. p. 13-19.
        </li>
        <li>Rosenblatt, P. C., Walsh, R. P., &amp; Jackson, D. A. (2011). Grief and mourning codes. World Cultures
            eJournal, 18(2).
        </li>
        <li>Ross, M. H. (1983). Political decision making and conflict: Additional cross-cultural codes and scales.
            Ethnology, 22(2), 169-192.
        </li>
        <li>Rozée-Koker, P. D. (1987). Cross-cultural codes on seven types of rape. Behavior Science Research, 21(1-4),
            101-117.
        </li>
        <li>Running, S. W., Nemani, R., Glassy, J. M., and Thornton, P. E. (1999). MODIS daily photosynthesis (PSN) and
            annual net primary production (NPP) product (MOD17) Algorithm Theoretical Basis Document. University of
            Montana, SCF At-Launch Algorithm ATBD Documents (available online at: www. ntsg. umt.
            edu/modis/ATBD/ATBD_MOD17_v21. pdf).
        </li>
        <li>Sanday, P. R. (1981). Female power and male dominance: On the origins of sexual inequality. Cambridge
            University Press.
        </li>
        <li>Schlegel, A., &amp; Barry, H. (1979). Adolescent initiation ceremonies: A cross-cultural code. Ethnology,
            18(2), 199-210.
        </li>
        <li>Schlegel, A., &amp; Eloul, R. (1987). A new coding of marriage transactions. Cross-Cultural Research,
            21(1-4), 118-140.
        </li>
        <li>Schroeder, S. (2001). Secondary disposal of the dead: cross-cultural codes. World Cultures, 12(1), 77-93.
        </li>
        <li>Sicoli, M. A., and Holton, G. (2014). Linguistic phylogenies support back-migration from Beringia to Asia.
            PloS one, 9(3), e91722.
        </li>
        <li>SIL International. (2015). ISO 639-3 Registration Authority. URL: <a href="http://www-01.sil.org/iso639-3/"
                                                                                 target="_blank">http://www-01.sil.org/iso639-3</a>.
        </li>
        <li>Tuden, A., &amp; Marshall, C. (1972). Political organization: Cross-cultural codes 4. Ethnology, 11(4),
            436-464.
        </li>
        <li>White, D. R. (1986). Forms and frequencies of polygyny: Standard Sample codes. World Cultures 2(2).</li>
        <li>White, D. R. (1989). Female contribution to subsistence: measurement and reliability. World Cultures.</li>
        <li>White, D. R. (1989). Kinship avoidance. World Cultures 5(4).</li>
        <li>White, D. R. (2009). Pinpointing sheets for the standard cross-cultural sample: complete edition. World
            Cultures eJournal, 17(1).
        </li>
        <li>White, D. R., &amp; Burton, M. L. (1988). Causes of polygyny: Ecology, economy, kinship, and warfare.
            American Anthropologist, 90(4), 871-887.
        </li>
        <li>Whiting, J. W., Sodergren, J. A., &amp; Stigler, S. M. (1982). Winter temperature as a constraint to the
            migration of preindustrial peoples. American Anthropologist, 84(2), 279-298.
        </li>
        <li>Whyte, M. K. (1978). Cross-cultural codes dealing with the relative status of women. Ethnology, 17(2),
            211-237.
        </li>
        <li>Whyte, M. K. (2015). The status of women in preindustrial societies. Princeton University Press.</li>
        <li>Winkelman, M. J. (1984). A cross-cultural study of magico-religious practitioners (Doctoral dissertation,
            University of California, Irvine).
        </li>
    </ul>
</%util:section>

