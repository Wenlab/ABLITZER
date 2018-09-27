function output = outputForABLITZERs(a)
  beginidx = 1;
  endidx = 0;
  for i = 1:length(a)
     num = length(a(i).FishStack);
   endidx = endidx + num;
    output(beginidx:endidx) = generate_output(a(i));
    beginidx=endidx+1;
  end
end
