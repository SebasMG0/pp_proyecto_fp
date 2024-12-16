declare

LocalPred = {NewCell nil}
Funcs = {NewCell nil}
Vars = {NewDictionary}
TempVar= {NewDictionary}

proc {ProcString Pred}
    case Pred of [10 102 117 110]|T then
        if @Funcs == nil then
            Funcs:= {AddVars T}| {GetSimDef @LocalPred}
        else
            Funcs:= @Funcs|{AddVars T} | {GetSimDef @LocalPred}
        end
        {Browse 'Función definida con sus variables y árbol:'}
        {Browse @Funcs}
    else
        {RedExec Pred}
    end
end

fun {GetSimDef Pred}
    case Pred of Op1|Sym|Op2 then
        tree(l:{CleanOp Op1} c:{List.nth Sym 1} r:{CleanOp {List.nth Op2 1}})
    else
        nil
    end
end

fun {CleanOp Pred}
    if {List.length Pred} == 1 then
        [Pred]
    else 
        {GetPar Pred}
    end
end

% fun {GetPar Pred Var Op} 
%     case Pred of H|T then
%         if H == 40 then
%             if Op == null then 
%                 {GetPar T nil nil}
%             else
%                 tree(l:tree(l:Op r:{GetPar T nil nil}) r:Var)
%             end

%         elseif H == 41 then
%             LocalPred:= T
%             tree(l:Op r:Var)
        
%         elseif {List.member H [42 43 45 47]} then
%             {GetPar T Var H}
        
%         elseif H == 13 then
%             LocalPred:= T
%             tree(l:Op r:Var)

%         else
%             if Var == nil then
%                 {GetPar T H nil}
%             else
%                 {GetPar T tree(l:tree(l:Op r:H) r:Var) nil}
%             end
%         end
%     end
% end

fun {GetPar Pred}
    case Pred of nil then nil
    [] H|T then
        if H == 40 then 
            {GetPar T}

        elseif H == 41 then
            {GetPar T}

        elseif {List.member H [42 43 45 47]} then
            H

        else
            case T of F|R then
                if F == 41 then
                    H
                else
                    tree(l:H c:F r: {GetPar R})
                end
            end
        end
    end
end

fun {AddVars Vars}
    case Vars of H|T then
        if H == "=" then LocalPred:=T nil
        else H|{AddVars T}
        end
    end
end

fun {Oper Op1 Op2 Sym}
    if Sym == 42 then
        Op1 * Op2
    elseif Sym == 43 then
        Op1 + Op2
    elseif Sym == 45 then
        Op1 - Op2 
    elseif Sym == 47 then
        Op1 / Op2
    end
end

fun {GetFunVars}
    case {List.nth {Record.toList @Funcs} 1} of nil then nil
    [] H|T then T end
end

fun {GetFunTree}
    {List.nth {Record.toList @Funcs} 2}
end

fun {GetFunName}
    {List.nth {List.nth {Record.toList @Funcs} 1} 1}
end

proc {RedExec Pred}
    case Pred of H|T then
        if H == {GetFunName} then
            LocalPred:= {DefParams T {GetFunVars} 1 Vars}
            {Browse 'Variables definidas'}
            {Browse {Dictionary.entries Vars}}

            LocalPred:= {GetFunTree}
            % LocalPred:= {Eval @LocalPred}
        end
    end
end

%----------------------------------------------------------------------
% Al final me quedó mal la función para evaluar y no puede completarla
%----------------------------------------------------------------------

% fun {Eval Tree}
%     case {String.is [Tree.l]} of H|T then
        
%     else
%         {Eval Tree.l}
%     end
% end

% fun {Eval Tree}
%     case Tree of
%        tree(l:L c:C r:R) then
%           Op1 = {Eval L}
%           Op2 = {Eval R}
%           {Oper Op1 Op2 C}
%     [] X then
%           if {Number.is X} then
%              X
%           else
%              {Dictionary.get Vars X}
%           end
%     end
%  end
 

fun {DefParams Pred LVars I D}
    case Pred of nil then nil
    [] H|T then
        if H == {GetFunName} then
            {Dictionary.put D {List.nth LVars I} {DefParams T LVars 1 TempVar}}
        else
            {Dictionary.put D {List.nth {List.nth LVars I} 1} H}
            {DefParams T LVars I+1 Vars}
        end
    end
end

proc {SplitInput Pred}
    case {String.tokens Pred &
    } of N|D|E|F then
        {ProcString {String.tokens D & }}
        % {Browse {String.tokens E & }}

        case E of H|T then 
            {ProcString {String.tokens T & }}
        end
    end
end


ExpA = "
fun operation x y z = (x*(x+y)) - (z/y)
operation 1 2 4
" 

ExpB="
fun twice x y = x + x
twice 5 7
"

{SplitInput ExpA}
% {SplitInput ExpB}

% {ProcString {SplitInput ExpA}}
% {ProcString C}


%% /////////////////////////////////////////////////////////////////////////////
%%
%% Es necesario que todo el código a probar esté dentro de las comillas pero
%% que no estén junto a ellas. Es decir, comillas dobles, en la siguiente línea empieza
%% el código y las comillas finales en una nueva línea.  
%%
%% - Las cosas entre paréntesis no utilizan espacios, si está fuera sí
%% - En cada paréntesis solo hay una operación (x+y) o (x+(y+z))
%% - Por simplicidad (tiempo) se ejecuta de a una sola expresión
%% /////////////////////////////////////////////////////////////////////////////
