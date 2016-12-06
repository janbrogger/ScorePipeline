function ScoreAssistJDBC()    
    restart = 0;
    jlp = [prefdir() '\javalibrarypath.txt'];
    jdbc_auth_path = [ScoreConfig.scoreBasePath 'matlab\jdbc\sqljdbc_6.0\enu\auth\x64\'];    
    jdbc_auth_path2 = strrep(jdbc_auth_path, '\', '\\');
    if not(exist(jlp, 'file'))        
        disp(['File not found: ' jlp]);
        fid = fopen(jlp,'wt');        
        fprintf(fid, jdbc_auth_path2);
        fclose(fid);
        restart = 1;
    else
        disp(['File found: ' jlp]);
    end
    
    jlpcontent = fileread(jlp);
    if isempty(strfind(jlpcontent, jdbc_auth_path))        
        disp('JDBC authorization not found in  the Java library path, adding it');
        fid = fopen(jlp,'at');
        fprintf(fid, ['\r\n' jdbc_auth_path2]);
        fclose(fid);
        restart = 1;
    else
        disp('JDBC path found in  the file, nothing to do');
    end
       
    jclp = [prefdir() '\javaclasspath.txt'];
    jdbc_path = [ScoreConfig.scoreBasePath 'matlab\jdbc\sqljdbc_6.0\enu\sqljdbc4.jar'];
    jdbc_path2 = strrep(jdbc_path, '\', '\\');
    if not(exist(jclp, 'file'))
        disp(['File not found: ' jlp]);
        fid = fopen(jclp,'wt');
        fprintf(fid, jdbc_path2);
        fclose(fid);
        restart = 1;
    else
        disp(['File found: ' jclp]);
    end
    
    jclpcontent = fileread(jclp);
    if isempty(strfind(jclpcontent, jdbc_path))
        
        disp('JDBC path not found in  the file, adding it');
        fid = fopen(jclp,'at');
        fprintf(fid, ['\r\n' jdbc_path2]);
        fclose(fid);
        restart = 1;
    else
        disp('JDBC path found in  the file, nothing to do');
    end
    
    if restart == 1
        error('Restart Matlab to complete JDBC setup');
    end
end