// Fase 3 — OCR inteligente: recebe o print de uma oferta de corrida (Uber,
// 99, inDrive, Maxim...) em base64, manda pra IA de visão e devolve os
// campos extraídos já estruturados. A imagem nunca é persistida em Storage
// — passa só pela memória da função. A chave da Anthropic mora só aqui
// (secret do projeto), nunca no app Flutter. O motorista sempre confirma os
// dados na tela de revisão antes de qualquer gravação — esta função nunca
// grava nada no banco.
import Anthropic from "npm:@anthropic-ai/sdk";

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const RIDE_EXTRACTION_TOOL = {
  name: "extract_ride_offer",
  description:
    "Extrai os dados estruturados de uma oferta de corrida (Uber, 99, inDrive, Maxim ou similar) a partir do print de tela enviado.",
  input_schema: {
    type: "object",
    properties: {
      platform: {
        type: "string",
        enum: ["uber", "99", "indrive", "maxim", "other"],
        description: "Plataforma identificada pelo layout/marca da tela.",
      },
      category: {
        type: ["string", "null"],
        description:
          "Categoria/produto da oferta, ex: 'UberX', '99 Comfort'. Null se não visível.",
      },
      origin_address: {
        type: ["string", "null"],
        description: "Endereço ou ponto de origem/embarque, como aparece na tela. Null se não visível.",
      },
      destination_address: {
        type: ["string", "null"],
        description: "Endereço ou ponto de destino, como aparece na tela. Null se não visível.",
      },
      gross_amount: {
        type: ["number", "null"],
        description: "Valor bruto da corrida em reais (só o número, sem 'R$'). Null se não visível.",
      },
      distance_to_pickup_km: {
        type: ["number", "null"],
        description: "Distância até o embarque em km. Null se não visível.",
      },
      trip_distance_km: {
        type: ["number", "null"],
        description: "Distância total da corrida em km. Null se não visível.",
      },
      estimated_duration_min: {
        type: ["integer", "null"],
        description: "Duração estimada da corrida em minutos. Null se não visível.",
      },
      payment_method: {
        type: ["string", "null"],
        enum: ["cash", "pix", "card", "app", null],
        description: "Forma de pagamento, se indicada na tela. Null se não visível.",
      },
    },
    required: [
      "platform",
      "category",
      "origin_address",
      "destination_address",
      "gross_amount",
      "distance_to_pickup_km",
      "trip_distance_km",
      "estimated_duration_min",
      "payment_method",
    ],
    additionalProperties: false,
  },
  strict: true,
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: CORS_HEADERS });
  }

  try {
    const { image_base64, mime_type } = await req.json();
    if (!image_base64 || typeof image_base64 !== "string") {
      return new Response(JSON.stringify({ error: "image_base64 é obrigatório." }), {
        status: 400,
        headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
      });
    }

    const apiKey = Deno.env.get("ANTHROPIC_API_KEY");
    if (!apiKey) {
      return new Response(JSON.stringify({ error: "ANTHROPIC_API_KEY não configurada." }), {
        status: 500,
        headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
      });
    }

    const anthropic = new Anthropic({ apiKey });

    const message = await anthropic.messages.create({
      model: "claude-opus-5",
      max_tokens: 1024,
      tools: [RIDE_EXTRACTION_TOOL],
      tool_choice: { type: "tool", name: RIDE_EXTRACTION_TOOL.name },
      messages: [
        {
          role: "user",
          content: [
            {
              type: "image",
              source: {
                type: "base64",
                media_type: mime_type ?? "image/jpeg",
                data: image_base64,
              },
            },
            {
              type: "text",
              text:
                "Esse é um print de tela de uma oferta de corrida de um app de motorista (Uber, 99, inDrive, Maxim ou similar). Extraia os dados visíveis usando a ferramenta disponível. Não invente valores que não estão na tela — use null.",
            },
          ],
        },
      ],
    });

    const toolUse = message.content.find(
      (block): block is Anthropic.ToolUseBlock => block.type === "tool_use",
    );

    if (!toolUse) {
      return new Response(JSON.stringify({ error: "IA não retornou dados estruturados." }), {
        status: 502,
        headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
      });
    }

    return new Response(JSON.stringify(toolUse.input), {
      status: 200,
      headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: String(error) }), {
      status: 500,
      headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
    });
  }
});
