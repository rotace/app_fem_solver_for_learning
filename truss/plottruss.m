# トラス要素と全体系の節点番号の描画，メッシュパラメータの出力
function plottruss(plflag,id)
loadValue;

nodes = mesh.nodes;
elems = mesh.elems;
# plot_trussフラグが'yes'ならばトラス要素を描画
if strcmpi(plflag.truss,'yes')==1;
    for i = 1:nel
        XX = [nodes(1,elems(1,i)) nodes(1,elems(2,i)) nodes(1,elems(1,i)) ];
        YY = [nodes(2,elems(1,i)) nodes(2,elems(2,i)) nodes(2,elems(1,i)) ];
        line(XX,YY);hold on;
        
        # plot_nodフラグが'yes'ならば全体系の節点番号を表示
        if strcmpi(plflag.nod,'yes')==1;
            text(XX(1),YY(1),sprintf('#0.5g',elems(1,i)));
            text(XX(2),YY(2),sprintf('#0.5g',elems(2,i)));
        end
    end
    title('Truss Plot');
end

# メッシュパラメータの出力
fprintf(1,'\tTruss Params \n');
fprintf(1,'No. of Elements #d \n',nel);
fprintf(1,'No. of Nodes    #d \n',nnp);
fprintf(1,'No.of Equations #d \n',neq);

