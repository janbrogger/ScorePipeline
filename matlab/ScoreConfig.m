classdef ScoreConfig
    properties (Constant)
        databaseName = 'HolbergAnon';
		databaseServer = 'localhost';
        scoreBasePath = 'J:\ScorePipeline\';
        eeglabPath = 'J:\eeglab';
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
            'ACECF7F5-27C1-4A5D-9EA4-3E8E5B7A1ECD' 'Øyne Åpne';
            'CA3FFF17-0814-4060-8B8A-7511A4CD885D' 'Blunker';
            '5ACBF52B-C130-41AD-B615-266E7CC4A784' 'Øyne Lukket';
            'A5A95645-A7F8-11CF-831A-0800091B5BDA' 'Annotation D';
            '65BB4425-FF4C-43D3-9FBF-2C022B76C100' 'Hoster';
            '71EECE80-EBC4-41c7-BF26-E56911426FB4' 'Recording Paused';
            '799B142D-6AA8-4BF3-9E6D-9BBE3B859419' 'Anmrk Kort'
            '1E8ABB48-B049-4147-83CC-8FE04E813530' 'Bevegelse'            
        }
    end
end