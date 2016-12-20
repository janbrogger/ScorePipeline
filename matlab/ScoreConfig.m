classdef ScoreConfig
    properties (Constant)
        databaseName = 'HolbergAnon';
		databaseServer = 'localhost';
        scoreBasePath = 'C:\Users\Jan\Documents\GitHub\ScorePipeline\';
        eeglabPath = 'C:\Users\Jan\Documents\GitHub\eeglab';
        debug = 1
        eventGuids = {
            'EE867C9B-F822-4B1E-AF3E-0B179DD6E0C0' 'Smertestimulerer';
            'ED986976-8E07-4C44-84CD-7624EB3323FB' 'Graphoelement';
            'C5C3A3BC-9683-43D6-A703-A74859CEA2A9' 'Event_EEG';
            'BBD1DA4C-62F4-4EE1-8F28-B5E83B82C575' 'Snakker til pas.';
            'B0A2B82D-C98F-4699-AF6A-BDE9CF4645A1' 'Øyne lukket';
            'A5A95601-A7F8-11CF-831A-0800091B5BDA' 'Øyne åpne';
            'A2A9E9A4-7EED-466B-B7F6-BB48F3140260' 'Event';
            '93A2CB2C-F420-4672-AA62-18989F768519' 'Detections Inactive';
            '8DA27322-155A-4A0C-A2D2-6DC03114BAA3' 'Klapper';
            '71EECE80-EBC4-41c7-BF26-E56911426FB4' 'Recording Paused';
            '32F2469E-6792-4CAD-8E11-B7747688BB8B' 'Unknown - SCORE?';
            '056F522F-DDA5-48B9-82E1-1A75C35CBC30' 'Unknown 2 - SCORE?';
            '01E4E4E6-EA8E-4c08-800C-B841D3C391C1' 'Video Review Progress';
            'F7744DB4-2EF5-4D31-8259-CBDFA8CDDF73' 'Rykning';
        }
    end
end