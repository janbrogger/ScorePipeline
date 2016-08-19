%EEGLAB group processing (STUDY) functions (studyfunc folder):
%  <a href="matlab:helpwin compute_ersp_times">compute_ersp_times</a>   - Computes the widest possible ERSP/ITC time window,...
%  <a href="matlab:helpwin neural_net">neural_net</a>           - Computes clusters using Matlab Neural Net toolbox.
%  <a href="matlab:helpwin pop_chanplot">pop_chanplot</a>         - Graphic user interface (GUI)-based function with plotting...
%  <a href="matlab:helpwin pop_clust">pop_clust</a>            - Select and run a clustering algorithm on components from an EEGLAB STUDY...
%  <a href="matlab:helpwin pop_clustedit">pop_clustedit</a>        - Graphic user interface (GUI)-based function with editing and plotting...
%  <a href="matlab:helpwin pop_erpimparams">pop_erpimparams</a>      - Set plotting and statistics parameters for...
%  <a href="matlab:helpwin pop_erpparams">pop_erpparams</a>        - Set plotting and statistics parameters for cluster ERP...
%  <a href="matlab:helpwin pop_erspparams">pop_erspparams</a>       - Set plotting and statistics parameters for...
%  <a href="matlab:helpwin pop_loadstudy">pop_loadstudy</a>        - Load an existing EEGLAB STUDY set of EEG datasets plus...
%  <a href="matlab:helpwin pop_preclust">pop_preclust</a>         - Prepare STUDY components' location and activity measures for later clustering.
%  <a href="matlab:helpwin pop_precomp">pop_precomp</a>          - Precompute measures (spectrum, ERP, ERSP) for a collection of data...
%  <a href="matlab:helpwin pop_savestudy">pop_savestudy</a>        - Save a STUDY structure to a disk file...
%  <a href="matlab:helpwin pop_specparams">pop_specparams</a>       - Set plotting and statistics parameters for computing...
%  <a href="matlab:helpwin pop_statparams">pop_statparams</a>       - Helper function for pop_erspparams, pop_erpparams, and...
%  <a href="matlab:helpwin pop_study">pop_study</a>            - Create a new STUDY set structure defining a group of related EEG datasets.
%  <a href="matlab:helpwin pop_studydesign">pop_studydesign</a>      - Create a STUDY design structure.
%  <a href="matlab:helpwin pop_studyerp">pop_studyerp</a>         - Create a simple design for ERP analysis...
%  <a href="matlab:helpwin robust_kmeans">robust_kmeans</a>        - An extension of Matlab kmeans() that removes outlier...
%  <a href="matlab:helpwin std_cell2setcomps">std_cell2setcomps</a>    - Convert .sets and .comps to cell array. The .sets and...
%  <a href="matlab:helpwin std_centroid">std_centroid</a>         - Compute cluster centroid in EEGLAB dataset STUDY.
%  <a href="matlab:helpwin std_changroup">std_changroup</a>        - Create channel groups for plotting.
%  <a href="matlab:helpwin std_chaninds">std_chaninds</a>         - Look up channel indices in a STUDY...
%  <a href="matlab:helpwin std_chantopo">std_chantopo</a>         - Plot ERP/spectral/ERSP topoplot at a specific...
%  <a href="matlab:helpwin std_checkconsist">std_checkconsist</a>     - Create channel groups for plotting.
%  <a href="matlab:helpwin std_checkfiles">std_checkfiles</a>       - Check all STUDY files consistency...
%  <a href="matlab:helpwin std_checkset">std_checkset</a>         - Check STUDY set consistency...
%  <a href="matlab:helpwin std_clustmaxelec">std_clustmaxelec</a>     - Function to find the electrode with maximum absolute projection...
%  <a href="matlab:helpwin std_clustread">std_clustread</a>        - This function has been replaced by std_readdata() for...
%  <a href="matlab:helpwin std_comppol">std_comppol</a>          - Inverse component polarity in a component cluster...
%  <a href="matlab:helpwin std_convertdesign">std_convertdesign</a>    - Temporary function converting STUDY design legacy...
%  <a href="matlab:helpwin std_createclust">std_createclust</a>      - Dreate a new empty cluster.  After creation, components...
%  <a href="matlab:helpwin std_dipoleclusters">std_dipoleclusters</a>   - Plots clusters of ICs as colored dipoles in MRI...
%  <a href="matlab:helpwin std_dipplot">std_dipplot</a>          - Commandline function to plot cluster component dipoles. Dipoles for each...
%  <a href="matlab:helpwin std_editset">std_editset</a>          - Modify a STUDY set structure.
%  <a href="matlab:helpwin std_erp">std_erp</a>              - Constructs and returns channel or ICA activation ERPs for a dataset.
%  <a href="matlab:helpwin std_erpimage">std_erpimage</a>         - Compute ERP images and save them on disk.
%  <a href="matlab:helpwin std_erpimageplot">std_erpimageplot</a>     - Commandline function to plot cluster ERPimage or channel erpimage.
%  <a href="matlab:helpwin std_erpplot">std_erpplot</a>          - Command line function to plot STUDY cluster component ERPs. Either...
%  <a href="matlab:helpwin std_ersp">std_ersp</a>             - Compute ERSP and/or ITC transforms for ICA components...
%  <a href="matlab:helpwin std_erspplot">std_erspplot</a>         - Plot STUDY cluster ERSPs. Displays either mean cluster ERSPs,...
%  <a href="matlab:helpwin std_figtitle">std_figtitle</a>         - Generate plotting figure titles in a cell array...
%  <a href="matlab:helpwin std_filecheck">std_filecheck</a>        - Check if ERSP or SPEC file contain specific parameters.
%  <a href="matlab:helpwin std_fileinfo">std_fileinfo</a>         - Check uniform channel distribution accross datasets...
%  <a href="matlab:helpwin std_findoutlierclust">std_findoutlierclust</a> - Determine whether an outlier cluster already exists...
%  <a href="matlab:helpwin std_findsameica">std_findsameica</a>      - Find groups of datasets with identical ICA decomposiotions...
%  <a href="matlab:helpwin std_getdataset">std_getdataset</a>       - Constructs and returns EEG dataset from STUDY design.
%  <a href="matlab:helpwin std_getindvar">std_getindvar</a>        - Get independent variables of a STUDY...
%  <a href="matlab:helpwin std_indvarmatch">std_indvarmatch</a>      - Match independent variable value in a list of values...
%  <a href="matlab:helpwin std_interp">std_interp</a>           - Interpolate, if needed, a list of named data channels...
%  <a href="matlab:helpwin std_itcplot">std_itcplot</a>          - Commandline function to plot cluster ITCs. Either displays mean cluster...
%  <a href="matlab:helpwin std_loadalleeg">std_loadalleeg</a>       - Constructs an ALLEEG structure, given the paths and file names...
%  <a href="matlab:helpwin std_makedesign">std_makedesign</a>       - Create a new or edit an existing STUDY.design by...
%  <a href="matlab:helpwin std_maketrialinfo">std_maketrialinfo</a>    - Create trial information structure using the...
%  <a href="matlab:helpwin std_mergeclust">std_mergeclust</a>       - Commandline function, to merge several clusters.
%  <a href="matlab:helpwin std_movecomp">std_movecomp</a>         - Move ICA component(s) from one cluster to another.
%  <a href="matlab:helpwin std_moveoutlier">std_moveoutlier</a>      - Commandline function, to reassign specified outlier component(s)...
%  <a href="matlab:helpwin std_movie">std_movie</a>            - Make movie in the frequency domain...
%  <a href="matlab:helpwin std_pac">std_pac</a>              - Compute or read PAC data (Phase Amplitude Coupling).
%  <a href="matlab:helpwin std_pacplot">std_pacplot</a>          - Commandline function to plot cluster PAC...
%  <a href="matlab:helpwin std_plot">std_plot</a>             - This function is outdated. Use std_plottf() to plot time/...
%  <a href="matlab:helpwin std_plotcurve">std_plotcurve</a>        - Plot ERP or spectral traces for a STUDY component...
%  <a href="matlab:helpwin std_plottf">std_plottf</a>           - Plot ERSP/ITC images a component...
%  <a href="matlab:helpwin std_preclust">std_preclust</a>         - Select measures to be included in computation of a preclustering array.
%  <a href="matlab:helpwin std_precomp">std_precomp</a>          - Precompute measures (ERP, spectrum, ERSP, ITC) for channels in a...
%  <a href="matlab:helpwin std_precomp_worker">std_precomp_worker</a>   - Allow dispatching ERSP to be computed in parallel...
%  <a href="matlab:helpwin std_prepare_neighbors">std_prepare_neighbors</a> - Prepare Fieldtrip channel neighbor structure.
%  <a href="matlab:helpwin std_propplot">std_propplot</a>         - Command line function to plot component cluster...
%  <a href="matlab:helpwin std_pvaf">std_pvaf</a>             - Compute 'percent variance accounted for' (pvaf) by specified...
%  <a href="matlab:helpwin std_readdata">std_readdata</a>         - LEGACY FUNCTION, SHOULD NOT BE USED ANYMORE. INSTEAD...
%  <a href="matlab:helpwin std_readerp">std_readerp</a>          - Load ERP measures for data channels or...
%  <a href="matlab:helpwin std_readerpimage">std_readerpimage</a>     - Load ERPimage measures for data channels or...
%  <a href="matlab:helpwin std_readersp">std_readersp</a>         - Load ERSP measures for data channels or  for all...
%  <a href="matlab:helpwin std_readfile">std_readfile</a>         - Read data file containing STUDY measures.
%  <a href="matlab:helpwin std_readitc">std_readitc</a>          - Load ITC measures for data channels or...
%  <a href="matlab:helpwin std_readpac">std_readpac</a>          - Read phase-amplitude correlation...
%  <a href="matlab:helpwin std_readspec">std_readspec</a>         - Load spectrum measures for data channels or...
%  <a href="matlab:helpwin std_readspecgram">std_readspecgram</a>     - Returns the stored mean power spectrogram for an ICA component...
%  <a href="matlab:helpwin std_readtopo">std_readtopo</a>         - Returns the scalp map of a specified ICA component, assumed...
%  <a href="matlab:helpwin std_readtopoclust">std_readtopoclust</a>    - Compute and return cluster component scalp maps.
%  <a href="matlab:helpwin std_rebuilddesign">std_rebuilddesign</a>    - Reduild design structure when datasets have been...
%  <a href="matlab:helpwin std_rejectoutliers">std_rejectoutliers</a>   - Commandline function, to reject outlier component(s) from clusters.
%  <a href="matlab:helpwin std_renameclust">std_renameclust</a>      - Commandline function, to rename clusters using specified (mnemonic) names.
%  <a href="matlab:helpwin std_renamestudyfiles">std_renamestudyfiles</a> - Rename files for design 1 if necessary. In design...
%  <a href="matlab:helpwin std_reset">std_reset</a>            - Remove all preloaded measures from STUDY...
%  <a href="matlab:helpwin std_rmalldatafields">std_rmalldatafields</a>  - Remove all data fields from STUDY (before saving...
%  <a href="matlab:helpwin std_savedat">std_savedat</a>          - Save measure for computed data...
%  <a href="matlab:helpwin std_selcomp">std_selcomp</a>          - Helper function for std_erpplot(), std_specplot()...
%  <a href="matlab:helpwin std_selectdataset">std_selectdataset</a>    - Select datasets and trials for a given independent...
%  <a href="matlab:helpwin std_selectdesign">std_selectdesign</a>     - Select an existing STUDY design.
%  <a href="matlab:helpwin std_selsubject">std_selsubject</a>       - Helper function for std_erpplot(), std_specplot()...
%  <a href="matlab:helpwin std_setcomps2cell">std_setcomps2cell</a>    - Convert .sets and .comps to cell array. The .sets and...
%  <a href="matlab:helpwin std_spec">std_spec</a>             - Returns the ICA component spectra for a dataset. Updates the EEG structure...
%  <a href="matlab:helpwin std_specgram">std_specgram</a>         - Returns the ICA component or channel spectrogram for a dataset.
%  <a href="matlab:helpwin std_specplot">std_specplot</a>         - Plot STUDY component cluster spectra, either mean spectra...
%  <a href="matlab:helpwin std_stat">std_stat</a>             - Compute statistics for ERP/spectral traces or ERSP/ITC images...
%  <a href="matlab:helpwin std_substudy">std_substudy</a>         - Create a sub-STUDY set by removing datasets, conditions, groups, or...
%  <a href="matlab:helpwin std_topo">std_topo</a>             - Uses topoplot() to get the interpolated Cartesian grid of the...
%  <a href="matlab:helpwin std_topoplot">std_topoplot</a>         - Command line function to plot cluster component and mean scalp maps.
%  <a href="matlab:helpwin std_uniformfiles">std_uniformfiles</a>     - Check uniform channel distribution accross data files...
%  <a href="matlab:helpwin std_uniformsetinds">std_uniformsetinds</a>   - Check uniform channel distribution accross datasets...
%  <a href="matlab:helpwin toporeplot">toporeplot</a>           - Re-plot a saved topoplot() output image (a square matrix)...
