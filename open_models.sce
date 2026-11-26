// Open the four complete, editable Xcos diagrams.
folder=get_absolute_file_path('open_models.sce');
loadXcosLibs();
for name=['01_original','02_corrected','03_half_gain','04_double_gain']
 xcos(folder+name+'.zcos');
end
