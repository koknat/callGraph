% Matlab
% /home/tools/matlab/mathworks_r2020a/bin/matlab example.m

function[returnValue]=foo(arg2)
    arg1 = 'a'
    bar(globalList{1})
end

function []=bar(myList)
    globalRunCount = globalRunCount + 1
    if ( globalRunCount < 2 )
        bar(myList)
    end
    disp('hello\n')
    baz()
end

function[]=baz()
    print('world %s\n', globalList{1})
end

% main program
globalRunCount = 0
globalList{1} = 'a'
globalList{2} = 'b'
foo()
baz()
