<?php

declare(strict_types=1);

namespace App\V1\Health\Presentation;

use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Attribute\Route;

final readonly class HealthAction
{
    #[Route(
        path: '/health',
        name: 'api_v1_health',
        methods: [Request::METHOD_GET]
    )]
    public function __invoke(): JsonResponse
    {
        return new JsonResponse(['status' => 'ok']);
    }
}
