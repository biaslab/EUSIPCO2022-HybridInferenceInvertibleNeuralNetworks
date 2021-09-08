using PGFPlotsX
using HDF5
using LaTeXStrings

begin
    data_x = h5read("exports/data/transformed_data.h5", "x_init")
    data_x_transformed = h5read("exports/data/transformed_data.h5", "x_transformed")
    data_x_hist = h5read("exports/data/transformed_data.h5", "x_hist")
    data_y = h5read("exports/data/transformed_data.h5", "y_init")
end

plt_data = @pgf GroupPlot(
    # group plot options
    {
        group_style = {
            group_size = "3 by 1",
            horizontal_sep = "1.5cm",
        },
        width = "\\textwidth / 3"
    },

    # axis 1 (input data)
    {
        xlabel=L"$\mu^{(1)}$",
        ylabel=L"$\mu^{(2)}$",
        grid = "major",
        style = {thick},
        title = "generated means"
    },
    # plots for axis 1
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
    
    # axis 2 (transformed)
    {
        xlabel=L"$g(\mu^{(1)})$",
        ylabel=L"$g(\mu^{(2)})$",
        grid = "major",
        style = {thick},
        title = "transformed means"
    },
    # plots for axis 2
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
            x = data_x_transformed[1,:], 
            y = data_x_transformed[2,:], 
            label = data_y
        ),
    ),

    # axis 3 (dot)
    {
        xlabel=L"$1^\top g(\mu)$",    # TODO: add bold font in paper!
        ylabel="Number of occurences",
        grid = "major",
        style = {thick},
        title = "transformed + reduced means"
    },
    # plots for axis 3
    Plot(
        {
            hist = {
                bins = 50,
                density = false,
                data_min = -35,
                data_max = 10
            },
            style = {
                fill = "blue"
            }
        }, 
        Table(
            x = data_x_hist,#[data_y .== 1.0],
            y = data_x_hist,#[data_y .== 1.0],
        ),
    ),
    Plot(
        {
            hist = {
                bins = 50,
                density = false,
                data_min = -35,
                data_max = 10
            },
            style = {
                fill = "red"
            }
        }, 
        Table(
            x = data_x_hist[data_y .== 1.0],
            y = data_x_hist[data_y .== 1.0],
        ),
    ),
)

pgfsave("exports/figures/transformed_data.tikz", plt_data)


