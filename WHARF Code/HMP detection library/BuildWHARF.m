% -------------------------------------------------------------------------
% Author: Barbara Bruno (dept. DIBRIS, University of Genova, ITALY)
%
% This code is the implementation of the algorithms described in the
% paper "Human motion modeling and recognition: a computational approach".
%
% I would be grateful if you refer to the paper in any academic
% publication that uses this code or part of it.
% Here is the BibTeX reference:
% @inproceedings{Bruno12,
% author = "B. Bruno and F. Mastrogiovanni and A. Sgorbissa and T. Vernazza and R. Zaccaria",
% title = "Human motion modeling and recognition: a computational approach",
% booktitle = "Proceedings of the 8th {IEEE} International Conference on Automation Science and Engineering ({CASE} 2012)",
% address = "Seoul, Korea",
% year = "2012",
% month = "August"
% }
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% This function is associated to the public dataset WHARF Data Set.
% (free download at: https://github.com/fulviomas/WHARF)
% The WHARF Data Set and its rationale are described in the paper "A Public
% Domain Dataset for ADL Recognition Using Wrist-placed Accelerometers".
%
% I would be grateful if you refer to the paper in any academic
% publication that uses this code or the WHARF Data Set.
% Here is the BibTeX reference:
% @inproceedings{Bruno14c,
% author = "B. Bruno and F. Mastrogiovanni and A. Sgorbissa",
% title = "A Public Domain Dataset for {ADL} Recognition Using Wrist-placed Accelerometers",
% booktitle = "Proceedings of the 23rd {IEEE} International Symposium on Robot and Human Interactive Communication ({RO-MAN} 2014)",
% address = "Edinburgh, UK",
% month = "August",
% year = "2014"
% }
% -------------------------------------------------------------------------
%
% BuildWHARF creates the models (with the Gaussian Mixture Modelling
% and Regression procedure) of the HMP of WHARF Data Set, each represented
% by a set of modelling trials stored in a specific folder. The module
% calls the fuction GenerateModel for each motion passing it the
% appropriate modelling folder. In addition, the function computes the
% model-specific threshold to be later used by the Classifier to
% discriminate between known and unknown motions.

% CREATE THE MODELS AND ASSOCIATED THRESHOLDS
scale = 1.5;  % experimentally set scaling factor for the threshold computation

% Open_Close_Curtains
disp('Building Open_Close_Curtains model...');
folder = 'Data\MODELS\Open_Close_Curtains_MODEL\';
[OPEN_CLOSE_CURTAINSgP, OPEN_CLOSE_CURTAINSgS, OPEN_CLOSE_CURTAINSbP, OPEN_CLOSE_CURTAINSbS] = GenerateModel(folder);
OPEN_CLOSE_CURTAINS_threshold = ComputeThreshold(OPEN_CLOSE_CURTAINSgP,OPEN_CLOSE_CURTAINSgS,OPEN_CLOSE_CURTAINSbP,OPEN_CLOSE_CURTAINSbS,scale);
models(1) = struct('name',{'Opencurtains'},'gP',OPEN_CLOSE_CURTAINSgP,'gS',OPEN_CLOSE_CURTAINSgS,'bP',OPEN_CLOSE_CURTAINSbP,'bS',OPEN_CLOSE_CURTAINSbS,'threshold',OPEN_CLOSE_CURTAINS_threshold);
clear OPEN_CLOSE_CURTAINSgP OPEN_CLOSE_CURTAINSgS OPEN_CLOSE_CURTAINSbP OPEN_CLOSE_CURTAINSbS OPEN_CLOSE_CURTAINS_threshold

% SAVE THE MODELS IN THE CURRENT DIRECTORY
save models_and_thresholds.mat