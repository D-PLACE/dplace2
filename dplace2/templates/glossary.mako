<%inherit file="home_comp.mako"/>
<%namespace name="util" file="util.mako"/>

<%def name="sidebar()">
    <div class="well well-small">
        <h4>Contents</h4>
        <ul class="unstyled">
            <li><a href="#q0">1. How do I get started with D-PLACE?</a></li>
            <li><a href="#q1">2. Who created D-PLACE?</a></li>
            <li><a href="#q2">3. How should I cite D-PLACE?</a></li>
            <li><a href="#q3">4. Who funded D-PLACE?</a></li>
            <li><a href="#q4">5, What is a “society”?</a></li>
            <li><a href="#q5">6. What is a “variable”?</a></li>
            <li><a href="#q6">7. Who decided on the possible codes to include for each variable?</a></li>
            <li><a href="#q7">8. What is the difference between a society set and a dataset?</a></li>
            <li><a href="#q8">9. Culture is dynamic. How is this captured in D-PLACE?</a></li>
            <li><a href="#q9">10. It seems like the same society (or variable) is sometimes included in more than one
                dataset, but each has different primary ID. How can I link societies/variables across datasets?</a></li>
            <li><a href="#q10">11. I identify as a member of a D-PLACE “society” and/or have concerns or questions about
                data in D-PLACE. How can I share my concerns?</a></li>
            <li><a href="#q11">12. I would like to contribute data to D-PLACE. Where do I start?</a></li>
            <li><a href="#q12">13. Why the emphasis on language and linguistic phylogenies?</a></li>
            <li><a href="#q13">14. Why should I use the D-PLACE version of a dataset I already have in digital form?</a>
            </li>
            <li><a href="#q14">15. Can I download the entire database, and work with it on a platform I prefer?</a></li>
        </ul>
    </div>
</%def>

<h2>FAQ</h2>

<%util:section title="1. How do I get started with D-PLACE?" level="4" id="q0">
    <p>
        D-PLACE lets you visualize cross-cultural data in three ways: as a list in a table, on a global map, or on a
        linguistic tree (i.e., phylogeny or classification). Data points (i.e., rows in the table, points on the map,
        points on the tree) represent the expression of a particular cultural feature by a particular society at a given
        time and place, as recorded by the <a href="${req.route_url('sources')}">Source</a>.
        Data points are colour-coded to allow
        you to quickly assess the diversity of a cultural feature across societies in the table, map, or linguistic
        tree.
    </p>
    <p>
        We suggest you start exploring D-PLACE via a search on the <a href="${req.route_url('parameters')}">Variables page</a>.
        ‘Variables’ in D-PLACE are cultural features or environmental parameters.
    </p>
    <p>
        For example, to explore cross-cultural variation in “Games”, start on the Variables page by typing “games” into
        the text box at the top of the first column.
    </p>
    <p>
        This should narrow the list of selectable variables from multiple thousand to a small handful. Each variable you
        see listed in the Variables search table was contributed as part of a particular cross-cultural
        <a href="${req.route_url('contributions')}">Dataset</a>
        and has been coded for a particular <a href="${req.route_url('societysets')}">Society Set</a>.
    </p>

    <p>
        Variables are listed by ‘name’ and unique ‘variable ID’ (e.g., “Games [EA035]”, “Games at Initial Funeral
        Ceremonies [SCCS1987]”), and can be sorted by “Dataset”.
    </p>
    <p>
        Select “Games [EA035]” by clicking on it (note that the variable ID “EA035” tells you this variable is from the
        Ethnographic Atlas (EA) dataset – see the Datasets page for more).
    </p>
    <p>
        You should now find yourself on a <a href="${req.route_url('parameter', id='EA035')}">results page for the “Games [EA035]” variable</a>.
        You will see its name and ID
        repeated at the top of the page, together with a definition that provides more information on how the variable
        was defined. In the orange box you will see the list of “possible codes” for the variable, as well as the
        colours that will be used to symbolise each code in the table, map and tree.
    </p>
    <p>
        You can now switch between a table view, map view and tree view of the coded variable by clicking on the
        ‘table’, ‘map’ or ‘tree’ icons. NOTE that to view your results on a tree, you must first choose the language
        family and/or particular phylogeny for which you would like a tree to be produced. You can explore available
        trees on the <a href="${req.route_url('phylogenys')}">Phylogenies page</a>.
    </p>
    <p>
        Note that you can also add additional variables to your selection at this point. Combining variables allows you
        to examine co-occurrence patterns for different cultural features. For example, you might be interested in how
        game type is related to a society’s <a href="${req.route_url('parameter', id='EA005')}">dependence on agriculture (EA005)</a>.
        In this case, you could start typing
        “agriculture” into the ‘Combine’ box, and select EA005 from the results that are offered to you. Tip: to
        maximize the number of societies from your first selection that will be covered by the second selection, make
        sure the second variable you select is from the same base Dataset (in this case, from the EA).
    </p>
</%util:section>


<%util:section title="2. Who created D-PLACE?" level="4" id="q1">
    <p>
        D-PLACE relies on existing cross-cultural, linguistic and environmental datasets that themselves are the product
        of decades of work by scientists, translators, transcribers and research participants. The D-PLACE database
        itself was designed and developed by a
        <a href="${req.route_url('about', _anchor='team')}">team of scientists</a> from a range of disciplines.
    </p>
</%util:section>

<%util:section title="3. How should I cite D-PLACE?" level="4" id="q2">
    <p>
        More information on citing D-PLACE is available
        <a href="${req.route_url('about', _anchor='howtocite')}">here</a>.
        Please be sure to cite the
        ${h.external_link('https://github.com/D-PLACE/dplace-data/releases', label='version of D-PLACE you used')},
        as we are constantly correcting the data.
    </p>
</%util:section>

<%util:section title="4. Who funded D-PLACE?" level="4" id="q3">
    <p>
        D-PLACE was developed with generous support from the
        ${h.external_link('https://nescent.org', label='National Evolutionary Synthesis Center')}}
        and the
        ${h.external_link('https://www.shh.mpg.de', label='Max Planck Institute for the Science of Human History')}.
    </p>
</%util:section>

<%util:section title="5. What is a “society”?" level="4" id="q4">
    <p>
        We use the term “society” to refer to cultural groups in the database. In most cases, a society can be
        understood to represent a group of people at a focal location with a shared language that differs from that of
        their neighbors. However, in some cases multiple societies share a language. There is also some variation among
        authors of different datasets in how societies are delineated, with the same cultural group embedded in a larger
        unit in one cross-cultural sample, but split into multiple groups in another. For example, the society Murdock
        (1967) refers to as
        <a href="${req.route_url('language', id='Nd29')}">Tunava</a> includes both the Deep Springs Valley and Fish
        Lake Valley Paiute groups, whereas Binford (2001) describes the
        <a href="${req.route_url('language', id='B211')}">Fish Lake</a> and
        <a href="${req.route_url('language', id='B206')}">Deep Springs Paiute</a> as distinct societies. D-PLACE
        highlights
        potential links among such societies by assigning them a matched “cross-dataset id” (xd_id), but leaves
        decisions on when and how to combine data to the user. Each society in D-PLACE must be accompanied by
        information on its geographic location (latitude and longitude coordinates), main year of documentation,
        language spoken, and primary sources (e.g., full citations for the ethnographic sources used to code cultural
        practices).
    </p>
</%util:section>

<%util:section title="6. What is a “variable”?" level="4" id="q5">
    <p>
        <a href="${req.route_url('parameters')}">Variables</a> are cultural features or practices, or environmental
        descriptors. Variables must be clearly defined
        (e.g., for a variable “Dependence on fishing”, what is meant by “dependence” (caloric contribution of fishing to
        the diet?, time spent on fishing relative to other subsistence activities?), and what is meant by “fishing”
        (does this include shellfish? aquatic mammals?). If categorical, variables must be accompanied by a list of
        possible ‘codes’ (e.g., variable: Marriage system; possible codes: Monogamous, Polygamous, Polyandrous).
        Variables can also be continuous (e.g., Total population, Annual rainfall) or ordinal (e.g., Relative settlement
        size, on a scale of 1-10).
    </p>
</%util:section>

<%util:section title="7. Who decided on the possible codes to include for each variable?" level="4" id="q6">
    <p>
        D-PLACE makes accessible existing, coded cultural datasets, and links them with information on environment,
        language and geography. Therefore, codes are determined before a dataset is imported into D-PLACE. In the case
        of the ‘core’ D-PLACE datasets, codes were defined by the authors of those datasets (e.g., Ethnographic Atlas
        codes by George P. Murdock, Binford Hunter-Gatherer codes by Lewis Binford (though, note that in some cases
        Binford adopted Murdock’s codes).
    </p>
</%util:section>

<%util:section title="8. What is the difference between a society set and a dataset?" level="4" id="q7">
    <p>
        A dataset is made up of one or more variables that have been coded for one or more societies (aka, a “society
        set”). See also the <a href="#q11">FAQ “I would like to contribute data to D-PLACE. Where do I start?”</a>
        for examples on how we define
        <a href="${req.route_url('societysets')}">society sets</a> and
        <a href="${req.route_url('contributions')}">datasets</a>.
    </p>
</%util:section>

<%util:section title="9. Culture is dynamic. How is this captured in D-PLACE?" level="4" id="q8">
    <p>
        Each datapoint in D-PLACE is tagged with information on the geographic location (latitude and longitude
        coordinates), year(“focal year”), language of the group to which it applies. In this way, we hope to make the
        specific group, time, and location to which a cultural observation applies as transparent as possible. When the
        same variable has been coded at multiple points in time, it may be possible to consider cultural change. To
        account for observer and coder bias, each datapoint is also tagged with a primary sources (e.g., source
        ethnography). We recommend users assess code reliability by returning to the primary source(s), and consulting
        additional sources, whenever feasible.
    </p>
</%util:section>

<%util:section title="10. It seems like the same society (or variable) is sometimes included in more than one dataset, but each has different primary ID. How can I link societies/variables across datasets? ?" level="4" id="q9">
    <p>
        We have not attempted to combine cultural data across different datasets, for two reasons. In the case of
        cultural variables, different coders/authors often used slightly different codes, coding scales and/or coding
        rules. In the case of societies, different authors often coded data for different time and place foci for the
        “same” society. Because cultural practices change over time and vary by region, code discrepancies are to be
        expected when these foci are different. For further discussion of these issues, please see the section
        “Combining cultural data across the EA and Binford datasets” in
        <a href="${req.route_url('about', _anchor='howtocite')}">Kirby et al. (2016)</a>. Despite these caveats, we
        have attempted to make it as easy as possible for users to identify similar variables and closely related
        societies across datasets. In the case of variables, users can search the
        <a href="${req.route_url('parameters')}">variables</a> table by keyword or theme;
        after selecting variables and considering the coding rules, decisions on when and how to combine data from the
        different datasets can be made. In the case of societies, we have assigned societies that share a focal location
        (though not necessarily a focal time) a shared cross-dataset id (xd_id). In addition, where justified, users
        might decide to group societies based on shared dialect and/or language. The
        <a href="${req.route_url('societysets')}">societies</a> table allows societies
        to be filtered by dialect/language.
    </p>
</%util:section>

<%util:section title="11. I identify as a member of a D-PLACE “society” and/or have concerns or questions about data in D-PLACE. How can I share my concerns?" level="4" id="q10">
    <p>
        We would love to hear from you. Please feel free to
        <a href="${req.route_url('contact')}">contact us directly</a>, or to post a comment to our public
        ${h.external_link('https://github.com/D-PLACE/dplace-data/issues', label='GitHub issues page')}.
        D-PLACE aims to make already-published information on culture more accessible –
        previously, many of the datasets in D-PLACE were available only in difficult-to-access academic journals, or as
        downloadable spreadsheets on the webpages of researchers working with the data. In publishing the data again
        here, we have tried to make as many of the ‘details’ surrounding each datapoint accessible with the data. For
        example, each record of a cultural feature is tagged with the specific time, place and subgroup of people to
        which the record applies. We have also tried to make primary sources easily available to D-PLACE users, so that
        observer and coder bias can be considered together with a given cultural ‘code’.
    </p>
</%util:section>

<%util:section title="12. I would like to contribute to D-PLACE. Where do I start?" level="4" id="q11">
    <p>
        We welcome contributions to D-PLACE, including both corrections to data and new contributions. Five types of
        contribution are possible:
    </p>
    <ol>
        <li>
            A new, independent society set: each society in a set must be accompanied by information on its geographic
            location (latitude and longitude coordinates), main year of documentation (“focal year”), language spoken,
            and primary sources (e.g., reference(s) for source ethnographies, and/or identity of observers). This
            ‘pinpointing’ information can be used by future contributors to ensure that additional variables are coded
            for the same group of people at the same time and place. An example of a stand-alone society set in D-PLACE
            is the HRAF society set [coming soon!].
        </li>
        <li>
            A new, independent variable (set): variables are cultural features or practices, or environmental
            descriptors. Variables must be clearly defined (e.g., What is meant by “Dependence on fishing?”. If
            categorical, variables must be accompanied by a list of possible ‘codes’ (e.g., variable: Marriage system;
            possible codes: Monogamous, Polygamous, Polyandrous). Examples of variable sets contributed to D-PLACE
            independently of any society sets include the environmental datasets listed here (values for each
            environmental variable have since been extracted for all societies in D-PLACE).
        </li>
        <li>
            A new variable (set), coded for an existing society set. Examples of this type of contribution are the
            various installments of the Standard Cross-Cultural Sample. Various scholars have published datasets on
            different themes, all using the 186 societies in the
            <a href="${req.route_url('societyset', id='SCCS')}">Standard Cross-Cultural Sample</a>
            as their basis.
        </li>
        <li>
            A new society set, coded for an existing variable (set). Examples of this type of contribution are the 2004
            and 2005 additions of societies in Siberia and Eastern Europe to the Ethnographic Atlas
            (Korotayev et al. 2004;
            Bondarenko et al. 2005). The 27 new societies were coded for all variables in the Ethnographic Atlas
            dataset, allowing them to be easily contrasted with the original 1264 societies coded by
            Murdock (1962-1971).
        </li>
        <li>
            A phylogeny: Published phylogenies can easily be incorporated into D-PLACE, allowing direct mapping of
            cultural features onto phylogeny. Ideally, contributed phylogenies will have their tips tagged with a
            language or dialect glottocode (glottolog.org), so they can be efficiently (and accurately) linked to
            societies in D-PLACE.
        </li>
    </ol>
    <p>
        Please contact us if you’d like to discuss a contribution, or would like to link your dataset to D-PLACE. You
        can also add suggestions for cross-cultural datasets that should be included in D-PLACE on
        ${h.external_link('https://github.com/D-PLACE/dplace-data/issues', label='GitHub')} –
        just open a new “Issue”, and tag that issue with the “Dataset” label.
    </p>
</%util:section>



<%util:section title="13. Why the emphasis on language and linguistic phylogenies?" level="4" id="q12">
    <p>
        The language spoken by a society is an important indicator of historical relatedness, cultural identity and
        contact. D-PLACE specifies the broad language family affiliation for all societies using the classification
        systems of ${h.external_link('https://glottolog.org', label='Glottolog')}. Users can treat language family
        as a variable of interest itself, or can use it as a coarse-level control for relatedness among societies.
    </p>
</%util:section>

<%util:section title="14. Why should I use the D-PLACE version of a dataset I already have in digital form?" level="4" id="q13">
    <p>
        D-PLACE is carefully documenting data corrections, of which we have had to make many. In compiling some of the
        ‘core’ D-PLACE datasets, we decided to “undo” decisions by early dataset digitizers to aggregate or ignore some
        codes, and to simplify variable and code definitions. (These early digitizers were often working with punch
        cards, so we understand the desire to simplify!) In the case of the Ethnographic Atlas, we re-digitized the
        original data tables from Murdock’s 20+ installments, each published as an article in the journal Ethnology.
        Many users have written to us to provide corrected geographic coordinates for particular societies (and we
        continue to work on improving the accuracy of lat/long coordinates for some datasets). We also have a number of
        linguists on our team, and have worked carefully to verify that society-language matches are correct. For more
        on the approach we have taken to digitization/dataset correction, please see the supplementary information of
        Kirby et al. 2016. More recent changes are being documented on our GitHub site, and therefore are publicly
        traceable. Finally, D-PLACE is being
        ${h.external_link('https://github.com/D-PLACE/dplace-data/releases', label='versioned')}
        and releases archived and accessible through
        ${h.external_link('https://doi.org/10.5281/zenodo.596376', label='ZENODO')},
        so any analyses that rely on D-PLACE can cite the particular version of the data that were used, enhancing
        replicability.
    </p>
</%util:section>

<%util:section title="15. Can I download the entire database, and work with it on a platform I prefer?" level="4" id="q14">
    <p>
        The folders in our
        ${h.external_link('https://github.com/D-PLACE/dplace-data/', label='data repository on GitHub')}
        include raw CSV files that can be downloaded and manipulated outside of D-PLACE.
        Please note the version of D-PLACE you download, as we are constantly correcting the datasets.
    </p>
    <p>
        If you work with the Python programming language, you may also use the Python package
        ${h.external_link('https://github.com/D-PLACE/pydplace', label='pydplace')} for programmatic
        access to D-PLACE data.
    </p>
</%util:section>
