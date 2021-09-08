using PGFPlotsX
using HDF5
using LaTeXStrings

begin
    data_x = h5read("exports/data/generated_data.h5", "x")
    data_y = h5read("exports/data/generated_data.h5", "y")
end

plt_data = @pgf Axis(
    # axis options
    {
        xlabel=L"$\mu^{(1)}$",
        ylabel=L"$\mu^{(2)}$",
        grid = "major",
        style = {thick},
        colorbar,
        colorbar_style = {
            title = "label"
        }
    },
    
    # plots for axis
    Plot(
        {
            scatter,
            only_marks,
            scatter_src="explicit"
        }, 
        Table(
            {
                meta = "label"
            },
            x = data_x[:,1], 
            y = data_x[:,2], 
            label = data_y
        ),
    ),
)

pgfsave("exports/figures/generated_data.tikz", plt_data)