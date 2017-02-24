function data = ScoreMouseDown(varargin)
    data = [];
    g = get(gcf,'UserData');
    cp = get(gca,'currentpoint');
    disp(['Current time position at left is ' num2str(g.time)]);
    disp(['Current time position at right is ' num2str(g.time+g.winlength*g.srate)]);
    clickedTime = g.time+cp(1)/g.srate;
    disp(['Clicked elapsed time : ' num2str(clickedTime)]);  
    disp(sprintf(' %03.5f', cp));
    disp('mousedown');
end