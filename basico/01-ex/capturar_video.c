// capturar_video.c
#include <libavdevice/avdevice.h>
#include <libavformat/avformat.h>
#include <libavutil/time.h>

int main()
{
    avdevice_register_all();

    AVFormatContext *input_ctx = NULL;
    AVFormatContext *output_ctx = NULL;
    AVPacket pkt;

    // Define dispositivo e formato (ajuste conforme sua distro/câmera)
    AVInputFormat *input_format = av_find_input_format("v4l2");
    if (!input_format)
    {
        fprintf(stderr, "Formato de entrada v4l2 não encontrado.\n");
        return 1;
    }

    // Abre a webcam (tente /dev/video0)
    if (avformat_open_input(&input_ctx, "/dev/video0", input_format, NULL) !=
        0)
    {
        fprintf(stderr, "Erro ao abrir o dispositivo de vídeo.\n");
        return 1;
    }

    // Cria arquivo de saída
    avformat_alloc_output_context2(&output_ctx, NULL, NULL, "saida.mp4");
    if (!output_ctx)
    {
        fprintf(stderr, "Erro ao criar contexto de saída.\n");
        return 1;
    }

    // Clona os streams de entrada para saída
    for (unsigned i = 0; i < input_ctx->nb_streams; i++)
    {
        AVStream *in_stream = input_ctx->streams[i];
        AVStream *out_stream = avformat_new_stream(output_ctx, NULL);
        avcodec_parameters_copy(out_stream->codecpar, in_stream->codecpar);
    }

    // Abre o arquivo de saída
    if (!(output_ctx->oformat->flags & AVFMT_NOFILE))
    {
        if (avio_open(&output_ctx->pb, "saida.mp4", AVIO_FLAG_WRITE) < 0)
        {
            fprintf(stderr, "Não foi possível abrir arquivo de saída.\n");
            return 1;
        }
    }

    avformat_write_header(output_ctx, NULL);

    // Captura por 10 segundos
    int64_t start_time = av_gettime();
    while (av_gettime() - start_time < 10 * AV_TIME_BASE)
    {
        if (av_read_frame(input_ctx, &pkt) >= 0)
        {
            AVStream *in_stream = input_ctx->streams[pkt.stream_index];
            AVStream *out_stream = output_ctx->streams[pkt.stream_index];

            // Ajusta timestamps
            pkt.pts = av_rescale_q_rnd(
                pkt.pts, in_stream->time_base, out_stream->time_base,
                AV_ROUND_NEAR_INF | AV_ROUND_PASS_MINMAX);
            pkt.dts = pkt.pts;
            pkt.duration = av_rescale_q(pkt.duration, in_stream->time_base,
                                        out_stream->time_base);

            av_interleaved_write_frame(output_ctx, &pkt);
            av_packet_unref(&pkt);
        }
    }

    av_write_trailer(output_ctx);
    avformat_close_input(&input_ctx);
    if (!(output_ctx->oformat->flags & AVFMT_NOFILE))
        avio_closep(&output_ctx->pb);
    avformat_free_context(output_ctx);

    return 0;
}
