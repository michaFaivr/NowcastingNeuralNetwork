%%%20141222
path_dir='./INPUTASCIIS/';
    switch RADSneighbor
       case 0
            name_input_file='globalAsciiRADS_IWP2_01020405060708091011121314151619212223new.txt'
        case 5
            name_input_file='globalAsciiRADS_IWP2_F01020405060708091011121314151619212223_05km_sigmas.txt' %05km better than nearest
        case 10
            name_input_file='globalAsciiRADS_IWP2_F01020405060708091011121314151619212223_10km_sigmas.txt'%10km better than 05km
        case 20
            name_input_file='globalAsciiRADS_IWP2_F01020405060708091011121314151619212223_20km_sigmas.txt'%lower than 05km
        case 15
            name_input_file='globalAsciiRADS_IWP2_F01020405060708091011121314151619212223_15km_sigmas.txt';
        case 30
            name_input_file='globalAsciiRADS_IWP2_F01020405060708091011121314151619212223_30km_sigmas.txt';
    end
    name_input_file=[path_dir name_input_file];
    try
        fileID=fopen(name_input_file, 'r');
    catch ME
        fprintf('%s\n','input doesnt exist');
        break;
    end
