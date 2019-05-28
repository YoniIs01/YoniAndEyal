Files = dir('D:\Google Drive\Documents\Research\Weathering model\New Runs 2019\results archive\Run 1');
j = 1;
FileNames = string.empty;
for i = 1:length(Files)
    if (~Files(i).isdir)
        FileNames(j) = strcat(Files(i).folder, '\' , Files(i).name);
        j = j + 1;
    end
end
j = 1;
for i = 1:11%length(FileNames )
    if endsWith(FileNames(i),'.mat')
        load(FileNames(i));
        Models(j) = Model_Data;
        j = j + 1;
    end
end
