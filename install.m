% compile libsvm and add the binaries to path

me = mfilename;                                             % what is my filename
mydir = which(me); mydir = mydir(1:end-2-numel(me));        % where am I located
addpath(mydir)
addpath( [ mydir '/Datasets' ]);
addpath([mydir '/Results'])
addpath( [ mydir '/NPSC' ]);
addpath( [ mydir '/CommonFiles' ]);
cd([ mydir 'lightspeed' ]);
install_lightspeed;
cd( mydir );