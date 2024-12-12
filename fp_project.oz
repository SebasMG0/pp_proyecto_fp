declare

%% /////////////////////////////////////////////////////////////////////////////
%%
%% Es necesario que todo el código a probar esté dentro de las comillas pero
%% que no estén junto a ellas. Es decir, comillas dobles, en la siguiente línea empieza
%% el código y las comillas finales en una nueva línea.  
%%
%% - Las cosas entre paréntesis no utilizan espacios, si está fuera sí: ((x+y+z)*2)
%%   ó (x+y+z) * 2 son correctos.
%% - Los paréntesis se usan para
%% /////////////////////////////////////////////////////////////////////////////

% L = "
% fun square x y = (x+y-z)
% " 
    
% C = {String.tokens L & }
% {Show C}

L = [120]
D= {NewDictionary}
{Dictionary.put D {List.nth L 1} 'alors'}

{Browse {Dictionary.get D {List.nth L 1}}}