function [scoreUserId, scoreUserName] = ScoreGetCurrentUser(failOnUnset)    
    scoreUserId = [];
    scoreUserName = [];
    if ~ismember('scoreUser',evalin('base','who')) || ~ismember('scoreUserId',evalin('base','who'))
        if failOnUnset
            error('SCORE current user not selected - see function ScoreSelectUser()');
        end
    else
            scoreUserId = evalin('base','scoreUserId');
            scoreUserName = evalin('base','scoreUser');
    end
    ScoreDebugLog(['ScoreGetCurrentUser: Current SCORE user is:' scoreUserName ' (UserId: ' num2str(scoreUserId) ')']);
end    