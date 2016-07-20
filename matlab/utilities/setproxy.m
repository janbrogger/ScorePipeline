%to fix HTTPS certificate error with EEGLAB,
%go to 
%C:\Program Files\MATLAB\R2009a Student\sys\java\jre\win32\jre\lib\security
%and edit
%cacerts
%using http://portecle.sourceforge.net/
%BUT still can't download fileIO directly
% so download it from 
%ftp://ftp.fieldtriptoolbox.org/pub/fieldtrip/modules
%and put it in J:\ScorePipeline\matlab\eeglab_current\plugins
%unzip the file and put the resulting directory one level up

testurl = 'https://sccn.ucsd.edu/wiki/Plugin_list_import';
handler = sun.net.www.protocol.https.Handler;

java.lang.System.setProperty('https.proxyHost','bgo-app107.ihelse.net')
java.lang.System.setProperty('https.proxyPort','3128')

url = java.net.URL([],testurl,handler);
urlConnection = url.openConnection;

inputStream = urlConnection.getInputStream;
byteArrayOutputStream = java.io.ByteArrayOutputStream;
isc = com.mathworks.mlwidgets.io.InterruptibleStreamCopier.getInterruptibleStreamCopier;
isc.copyStream(inputStream,byteArrayOutputStream);
inputStream.close;
byteArrayOutputStream.close;
output = native2unicode(typecast(byteArrayOutputStream.toByteArray','uint8'),'UTF-8');
output

