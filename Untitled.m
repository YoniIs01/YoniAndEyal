Vor_y_index
Vor_x_index
figure
hold all
for k=1:size(Vor_y_index,2)
  p(k)=plot(Vor_x_index(:,k),Vor_y_index(:,k)); 
  if (mod(k,2))
  set(p(k),'Color',[1/k 1/k 0.1]);
  else
  set(p(k),'Color',[0 1 1/k]);    
  end
end