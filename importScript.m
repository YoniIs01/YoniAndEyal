Files = dir('D:\Program Files\Results Archive');
j = 1;
FileNames = string.empty;
for i = 1:length(Files)
    if (~Files(i).isdir)
        FileNames(j) = strcat(Files(i).folder, '\' , Files(i).name);
        j = j + 1;
    end
end
j = 1;
for i = 1:length(FileNames )
    if endsWith(FileNames(i),'.mat')
        load(FileNames(i));
        Models(j) = Model_Data;
        j = j + 1;
    end
end
