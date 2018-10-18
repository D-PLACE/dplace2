<%inherit file="home_comp.mako"/>
<%namespace name="util" file="util.mako"/>

<%def name="sidebar()">
    <div class="well well-small">
        <h4>Contents</h4>
        <ul class="unstyled">
            <li><a href="#q1">1. Who created D-PLACE?</a></li>
            <li><a href="#q2">2. How should I cite D-PLACE?</a></li>
            <li><a href="#q3">3. Who funded D-PLACE?</a></li>
            <li><a href="#q4">4, What is a “society”?</a></li>
            <li><a href="#q5">5. What is a “variable”?</a></li>
            <li><a href="#q6">6. Who decided on the possible codes to include for each variable?</a></li>
            <li><a href="#q7">7. What is the difference between a society set and a dataset?</a></li>
            <li><a href="#q8">8. Culture is dynamic. How is this captured in D-PLACE?</a></li>
            <li><a href="#q9">9. It seems like the same society (or variable) is sometimes included in more than one
                dataset, but each has different primary ID. How can I link societies/variables across datasets?</a></li>
            <li><a href="#q10">10. I identify as a member of a D-PLACE “society” and/or have concerns or questions about
                data in D-PLACE. How can I share my concerns?</a></li>
            <li><a href="#q11">11. I would like to contribute data to D-PLACE. Where do I start?</a></li>
        </ul>
    </div>
</%def>

<h2>FAQ</h2>

<%util:section title="1. Who created D-PLACE?" level="4" id="q1">
    <p>
        The 
        ## FIXME: link!
        D-PLACE team 
        is made up of scientists with a broad range of interests who share a passion for
        interdisciplinary inquiry. Pulling the database together has required a large network of contributors. And,.of
        course, D-PLACE would not exist without the cultural datasets upon which it relies: we would like to acknowledge
        in particular the years of work by George P. Murdock, Lewis R. Binford, Joseph Jorgensen in compiling the
        datasets, and the long-term effort of other scholars in the field to maintain and update the datasets in the
        time since their original publication.
    </p>
</%util:section>

<%util:section title="2. How should I cite D-PLACE?" level="4" id="q2">
    <p>
        More information on: citing D-PLACE.is available
        ## FIXME: link!
        here.
        Please be sure to cite the version of D-PLACE you used,
        as we are constantly correcting the data.
    </p>
</%util:section>

<%util:section title="3. Who funded D-PLACE?" level="4" id="q3">
    <p>
        ## FIXME: link!
        D-PLACE was developed with generous support from the National Evolutionary Synthesis Center (www.nescent.org)
        and the Max Planck Institute for the Science of Human History (www.shh.mpg.de/en)
    </p>
</%util:section>

<%util:section title="4. What is a “society”?" level="4" id="q4">
    <p>
        We use the term “society” to refer to cultural groups in the database. In most cases, a society can be
        understood to represent a group of people at a focal location with a shared language that differs from that of
        their neighbors. However, in some cases multiple societies share a language. There is also some variation among
        authors of different datasets in how societies are delineated, with the same cultural group embedded in a larger
        unit in one cross-cultural sample, but split into multiple groups in another. For example, the society Murdock
        (1967) refers to as “Tunava” includes both the Deep Springs Valley and Fish Lake Valley Paiute groups, whereas
        Binford (2001) describes the Fish Lake and Deep Springs Paiute as distinct societies. D-PLACE highlights
        potential links among such societies by assigning them a matched “cross-dataset id” (xd_id), but leaves
        decisions on when and how to combine data to the user. Each society in D-PLACE must be accompanied by
        information on its geographic location (latitude and longitude coordinates), main year of documentation,
        language spoken, and primary sources (e.g., full citations for the ethnographic sources used to code cultural
        practices).
    </p>
</%util:section>

<%util:section title="5. What is a “variable”?" level="4" id="q5">
    <p>
        Variables are cultural features or practices, or environmental descriptors. Variables must be clearly defined
        (e.g., for a variable “Dependence on fishing”, what is meant by “dependence” (caloric contribution of fishing to
        the diet?, time spent on fishing relative to other subsistence activities?), , and what is meant by “fishing”
        (does this include shellfish? aquatic mammals?). If categorical, variables must be accompanied by a list of
        possible ‘codes’ (e.g., variable: Marriage system; possible codes: Monogamous, Polygamous, Polyandrous).
        Variables can also be continuous (e.g., Total population, Annual rainfall) or ordinal (e.g., Relative settlement
        size, on a scale of 1-10).
    </p>
</%util:section>

<%util:section title="6. Who decided on the possible codes to include for each variable?" level="4" id="q6">
    <p>
        D-PLACE makes accessible existing, coded cultural datasets, and links them with information on environment,
        language and geography. Therefore, codes are determined before a dataset is imported into D-PLACE. In the case
        of the ‘core’ D-PLACE datasets, codes were defined by the authors of those datasets (e.g., Ethnographic Atlas
        codes by George P. Murdock, Binford Hunter-Gatherer codes by Lewis Binford (though, note that in some cases
        Binford adopted Murdock’s codes).
    </p>
</%util:section>

<%util:section title="7. What is the difference between a society set and a dataset?" level="4" id="q7">
    <p>
        A dataset is made up of one or more variables that have been coded for one or more societies (aka, a “society
        set”). See also the FAQ q11 “I would like to contribute data to D-PLACE. Where do I start?” for examples on how
        we define society sets and datasets.
    </p>
</%util:section>

<%util:section title="8. Culture is dynamic. How is this captured in D-PLACE?" level="4" id="q8">
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

<%util:section title="9. It seems like the same society (or variable) is sometimes included in more than one dataset, but each has different primary ID. How can I link societies/variables across datasets? ?" level="4" id="q9">
    <p>
        We have not attempted to combine cultural data across different datasets, for two reasons. In the case of
        cultural variables, different coders/authors often used slightly different codes, coding scales and/or coding
        rules. In the case of societies, different authors often coded data for different time and place foci for the
        “same” society. Because cultural practices change over time and vary by region, code discrepancies are to be
        expected when the these foci are different. For further discussion of these issues, please see the section
        “Combining cultural data across the EA and Binford datasets” in Kirby et al. (2016). Despite these caveats, we
        have attempted to make it as easy as possible for users to identify similar variables and closely related
        societies across datasets. In the case of variables, users can search the “variables” table by keyword or theme;
        after selecting variables and considering the coding rules, decisions on when and how to combine data from the
        different datasets can be made. In the case of societies, we have assigned societies that share a focal location
        (though not necessarily a focal time) a shared cross-dataset id (xd_id). In addition, where justified, users
        might decide to group societies based on shared dialect and/or language. The “societies” table allows societies
        to be filtered by dialect/language.
    </p>
</%util:section>

<%util:section title="10. I identify as a member of a D-PLACE “society” and/or have concerns or questions about data in D-PLACE. How can I share my concerns?" level="4" id="q10">
    <p>
        We would love to hear from you. Please feel free to contact us directly, or to post a comment to our public
        GitHub “issues” page. D-PLACE aims to make already-published information on culture more accessible –
        previously, many of the datasets in D-PLACE were available only in difficult-to-access academic journals, or as
        downloadable spreadsheets on the webpages of researchers working with the data. In publishing the data again
        here, we have tried to make as many of the ‘details’ surrounding each datapoint accessible with the data. For
        example, each record of a cultural feature is tagged with the specific time, place and subgroup of people to
        which the record applies. We have also tried to make primary sources easily available to D-PLACE users, so that
        observer and coder bias can be considered together with a given cultural ‘code’.
    </p>
</%util:section>

<%util:section title="11. I would like to contribute to D-PLACE. Where do I start?" level="4" id="q11">
    <p>
        We welcome contributions to D-PLACE, including both corrections to data and new contributions. Five types of
        contribution are possible:
    </p>
    <ol>
        <li>A new, independent society set: each society in a set must be accompanied by information on its geographic
        location (latitude and longitude coordinates), main year of documentation (“focal year”), language spoken, and
        primary sources (e.g., reference(s) for source ethnographies, and/or identity of observers). This ‘pinpointing’
        information can be used by future contributors to ensure that additional variables are coded for the same group
        of people at the same time and place. An example of a stand-alone society set in D-PLACE is the HRAF society set
            [coming soon!]</li>
        <li>A new, independent variable (set): variables are cultural features or practices, or environmental
        descriptors. Variables must be clearly defined (e.g., What is meant by “Dependence on fishing?”. If categorical,
        variables must be accompanied by a list of possible ‘codes’ (e.g., variable: Marriage system; possible codes:
        Monogamous, Polygamous, Polyandrous). Examples of variable sets contributed to D-PLACE independently of any
        society sets include the environmental datasets listed here (values for each environmental variable have since
            been extracted for all societies in D-PLACE)</li>
        <li>A new variable (set), coded for an existing society set. Examples of this type of contribution are the
        various installments of the Standard Cross-Cultural Sample. Various scholars have published datasets on
            different themes, all using the 186 societies in the Standard Cross-Cultural Sample as their basis.</li>
        <li>A new society set, coded for an existing variable (set). Examples of this type of contribution are the 2004
        and 2005 additions of societies in Siberia and Eastern Europe to the Ethnographic Atlas (Korotayev et al. 2004;
        Bondarenko et al. 2005). The 27 new societies were coded for all variables in the Ethnographic Atlas dataset,
            allowing them to be easily contrasted with the original 1264 societies coded by Murdock (1962-1971).</li>
        <li>A phylogeny: Published phylogenies can easily be incorporated into D-PLACE, allowing direct mapping of
        cultural features onto phylogeny. Ideally, contributed phylogenies will have their tips tagged with a language
        or dialect glottocode (glottolog.org), so they can be efficiently (and accurately) linked to societies in
            D-PLACE.</li>
    </ol>
    <p>
        Please contact us if you’d like to discuss a contribution, or would like to link your dataset to D-PLACE. You
        can also add suggestions for cross-cultural datasets that should be included in D-PLACE on our GitHub page –
        just start a new “Issue”, and tag that issue with the “Dataset” label.
    </p>
</%util:section>
